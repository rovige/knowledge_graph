package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.entity.*;
import com.smartdata.kg.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class DataTaskService extends ServiceImpl<DataTaskRepository, DataTask> {

    private final CompanyService companyService;
    private final NewsService newsService;
    private final GraphNodeService graphNodeService;
    private final GraphEdgeService graphEdgeService;
    private final DataTaskRepository dataTaskRepository;
    private final IndustryService industryService;

    private final Random random = new Random();
    private final ExecutorService executorService = Executors.newFixedThreadPool(8);

    public DataTask createAndStartTask(Long industryId, String industryName) {
        DataTask task = new DataTask();
        task.setIndustryId(industryId);
        task.setIndustryName(industryName);
        task.setTaskType("INDUSTRY_DATA");
        task.setStatus("PENDING");
        task.setProgress(0);
        task.setStartTime(LocalDateTime.now());
        this.save(task);
        
        generateIndustryDataAsync(task.getId(), industryId, industryName);
        return task;
    }

    public Page<DataTask> getTaskPage(int current, int size) {
        return this.page(
            new Page<>(current, size),
            new LambdaQueryWrapper<DataTask>()
                .orderByDesc(DataTask::getCreateTime)
        );
    }

    public boolean cancelTask(Long taskId) {
        DataTask task = this.getById(taskId);
        if (task != null && ("PENDING".equals(task.getStatus()) || "RUNNING".equals(task.getStatus()))) {
            task.setStatus("CANCELLED");
            task.setEndTime(LocalDateTime.now());
            this.updateById(task);
            return true;
        }
        return false;
    }

    @Async
    @Transactional
    public void generateIndustryDataAsync(Long taskId, Long industryId, String industryName) {
        try {
            log.info("开始生成行业 {} 的数据，任务ID: {}", industryName, taskId);
            
            updateTaskStatus(taskId, "RUNNING", 5);
            Thread.sleep(300);
            
            updateTaskStatus(taskId, "RUNNING", 10);
            List<Company> companies = generateCompanies(taskId, industryId, industryName);
            
            updateTaskStatus(taskId, "RUNNING", 40);
            generateNewsAsync(taskId, companies);
            
            updateTaskStatus(taskId, "RUNNING", 75);
            generateGraphData(taskId, industryId, industryName, companies);
            
            updateTaskStatus(taskId, "COMPLETED", 100);
            // 标记行业为已生成数据
            updateIndustryHasData(industryId, 1);
            log.info("行业 {} 数据生成完成！", industryName);
            
        } catch (InterruptedException e) {
            log.info("任务 {} 被中断", taskId);
            updateTaskStatus(taskId, "CANCELLED", 0);
        } catch (Exception e) {
            log.error("数据生成失败", e);
            updateTaskStatus(taskId, "FAILED", 0);
            DataTask task = getById(taskId);
            if (task != null) {
                task.setErrorMessage(e.getMessage());
                updateById(task);
            }
        }
    }

    private void updateTaskStatus(Long taskId, String status, int progress) {
        DataTask task = getById(taskId);
        if (task != null) {
            task.setStatus(status);
            task.setProgress(progress);
            if ("COMPLETED".equals(status) || "FAILED".equals(status) || "CANCELLED".equals(status)) {
                task.setEndTime(LocalDateTime.now());
            }
            updateById(task);
        }
    }

    private List<Company> generateCompanies(Long taskId, Long industryId, String industryName) throws InterruptedException {
        List<Company> companies = new ArrayList<>();
        String[] companySuffixes = {"科技", "集团", "控股", "股份", "有限责任", "投资", "发展", "创新", "未来", "智慧"};
        String[] prefixes = {"中科", "华夏", "领航", "先锋", "智联", "云端", "数字", "创新", "科技", "未来"};
        String[] legalNames = {"张三", "李四", "王五", "赵六", "钱七", "孙八", "周九", "吴十", "郑十一", "王十二"};
        String[] addresses = {"北京市朝阳区科技园区", "上海市浦东新区张江高科技园", "深圳市南山区科技园", "杭州市余杭区未来科技城", "广州市天河区珠江新城"};

        for (int i = 0; i < 10; i++) {
            Company company = new Company();
            company.setIndustryId(industryId);
            String name = prefixes[i % prefixes.length] + industryName + companySuffixes[i % companySuffixes.length] + "有限公司";
            company.setName(name);
            company.setCode("COMP" + String.format("%06d", industryId * 100 + i));
            company.setLegalRepresentative(legalNames[i % legalNames.length]);
            company.setAddress(addresses[i % addresses.length] + (i + 1) + "号楼");
            company.setBusinessScope("从事" + industryName + "相关技术研发、生产、销售、服务；技术咨询、技术转让、技术服务。");
            company.setRegisteredCapital(new BigDecimal(100000000 + random.nextInt(900000000)));
            company.setEstablishmentDate(LocalDateTime.of(2010 + random.nextInt(14), 1 + random.nextInt(12), 1 + random.nextInt(28), 0, 0));
            company.setRanking(i + 1);
            company.setStatus("ACTIVE");
            
            companyService.save(company);
            companies.add(company);
            
            int progress = 12 + (i + 1) * 3;
            updateTaskStatus(taskId, "RUNNING", progress);
            Thread.sleep(50);
        }
        
        log.info("生成了 {} 家企业数据", companies.size());
        return companies;
    }

    private void generateNewsAsync(Long taskId, List<Company> companies) throws InterruptedException, ExecutionException {
        List<Future<?>> futures = new ArrayList<>();
        
        for (Company company : companies) {
            futures.add(executorService.submit(() -> {
                try {
                    generateNewsForCompany(company);
                } catch (Exception e) {
                    log.error("生成企业 {} 新闻失败", company.getName(), e);
                }
            }));
        }
        
        int totalNews = 0;
        for (int i = 0; i < futures.size(); i++) {
            futures.get(i).get();
            totalNews += 5;
            
            int progress = 42 + (totalNews * 30) / (companies.size() * 5);
            updateTaskStatus(taskId, "RUNNING", progress);
        }
        
        log.info("生成了 {} 条新闻数据", totalNews);
    }

    private void generateNewsForCompany(Company company) {
        String[] newsTitles = {
            "{}获得重大技术突破，引领行业发展",
            "{}与知名企业签署战略合作协议",
            "{}发布年度财务报告，业绩稳步增长",
            "{}新产品发布会成功举办，市场反响热烈",
            "{}荣获行业年度大奖，彰显实力"
        };
        String[] sources = {"财经日报", "科技周刊", "行业观察", "商业评论", "经济导报", "科技前沿", "商业周刊"};
        String[] summaries = {
            "近日，该公司在技术研发方面取得重要突破，相关成果已应用到实际生产中。",
            "双方将在技术创新、市场拓展等方面开展深度合作，共同推动行业发展。",
            "公司财务报告显示，本财年营收和利润均实现稳步增长，发展势头良好。",
            "新产品采用了最新技术，性能优越，受到市场和客户的广泛认可。",
            "该公司凭借其卓越的技术实力和市场表现，荣获行业重要奖项。"
        };

        List<News> newsList = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            News news = new News();
            news.setCompanyId(company.getId());
            news.setTitle(newsTitles[i % newsTitles.length].replace("{}", company.getName()));
            news.setSummary(summaries[i % summaries.length]);
            news.setContent("详细新闻内容...这里展示新闻的详细正文内容，包括事件背景、过程、影响等信息。" +
                    "该新闻内容丰富，数据详实，为读者提供全面的资讯。");
            news.setSource(sources[random.nextInt(sources.length)]);
            news.setUrl("https://example.com/news/" + company.getId() + "/" + i);
            news.setPublishTime(LocalDateTime.now().minusDays(random.nextInt(30)).minusHours(random.nextInt(24)));
            news.setType(1);
            news.setStatus("PUBLISHED");
            newsList.add(news);
        }
        
        newsService.saveBatch(newsList);
    }

    private void generateGraphData(Long taskId, Long industryId, String industryName, List<Company> companies) throws InterruptedException {
        GraphNode industryNode = new GraphNode();
        industryNode.setName(industryName);
        industryNode.setType("INDUSTRY");
        industryNode.setIndustryId(industryId);
        industryNode.setStatus(1);
        industryNode.setProperties("{\"description\":\"" + industryName + "产业链分析\"}");
        graphNodeService.save(industryNode);
        updateTaskStatus(taskId, "RUNNING", 78);
        Thread.sleep(100);

        List<GraphNode> companyNodes = new ArrayList<>();
        List<GraphEdge> edges = new ArrayList<>();
        
        for (int i = 0; i < companies.size(); i++) {
            Company company = companies.get(i);
            
            GraphNode companyNode = new GraphNode();
            companyNode.setName(company.getName());
            companyNode.setType("COMPANY");
            companyNode.setIndustryId(industryId);
            String properties = "{\"companyId\":" + company.getId() + 
                               ",\"ranking\":" + company.getRanking() + 
                               ",\"legalRepresentative\":\"" + company.getLegalRepresentative() + "\"}";
            companyNode.setProperties(properties);
            companyNode.setStatus(1);
            graphNodeService.save(companyNode);
            companyNodes.add(companyNode);

            GraphEdge includeEdge = new GraphEdge();
            includeEdge.setSourceNodeId(industryNode.getId());
            includeEdge.setTargetNodeId(companyNode.getId());
            includeEdge.setRelationType("INCLUDES");
            includeEdge.setIndustryId(industryId);
            includeEdge.setProperties("{\"description\":\"行业包含企业\"}");
            includeEdge.setStatus(1);
            edges.add(includeEdge);
            
            int progress = 78 + (i + 1) * 2;
            updateTaskStatus(taskId, "RUNNING", progress);
            Thread.sleep(30);
        }

        if (companies.size() >= 3) {
            for (int i = 0; i < companyNodes.size() - 1; i++) {
                GraphEdge supplyEdge = new GraphEdge();
                supplyEdge.setSourceNodeId(companyNodes.get(i).getId());
                supplyEdge.setTargetNodeId(companyNodes.get(i + 1).getId());
                supplyEdge.setRelationType("SUPPLIES_TO");
                supplyEdge.setIndustryId(industryId);
                supplyEdge.setProperties("{\"description\":\"供应链关系：上游供应商→下游制造商\"}");
                supplyEdge.setStatus(1);
                edges.add(supplyEdge);
                Thread.sleep(20);
            }

            for (int i = 0; i < companyNodes.size(); i += 2) {
                if (i + 2 < companyNodes.size()) {
                    GraphEdge coopEdge = new GraphEdge();
                    coopEdge.setSourceNodeId(companyNodes.get(i).getId());
                    coopEdge.setTargetNodeId(companyNodes.get(i + 2).getId());
                    coopEdge.setRelationType("COOPERATES_WITH");
                    coopEdge.setIndustryId(industryId);
                    coopEdge.setProperties("{\"description\":\"战略合作关系\"}");
                    coopEdge.setStatus(1);
                    edges.add(coopEdge);
                    Thread.sleep(20);
                }
            }
        }
        
        graphEdgeService.saveBatch(edges);
        log.info("生成了 {} 个节点和 {} 条关系", companyNodes.size() + 1, edges.size());
    }

    private void updateIndustryHasData(Long industryId, Integer hasData) {
        try {
            Industry industry = industryService.getById(industryId);
            if (industry != null) {
                industry.setHasData(hasData);
                industryService.updateById(industry);
                log.info("行业 {} hasData 状态更新为: {}", industry.getName(), hasData);
            }
        } catch (Exception e) {
            log.error("更新行业 hasData 状态失败", e);
        }
    }
}
