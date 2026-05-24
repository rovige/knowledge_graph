// =============================================
// 智慧数据平台 - Neo4j 初始化脚本
// 创建日期: 2026-05-23
// 说明: 创建示例知识图谱数据
// =============================================

// 清除现有数据（谨慎使用）
// MATCH (n) DETACH DELETE n;

// =============================================
// 1. 创建行业节点
// =============================================
CREATE (ai:Industry {id: 101, name: '人工智能', code: 'AI', description: '人工智能领域'})
CREATE (bigdata:Industry {id: 102, name: '大数据', code: 'BIG_DATA', description: '大数据领域'})
CREATE (cloud:Industry {id: 103, name: '云计算', code: 'CLOUD', description: '云计算领域'})
CREATE (new_energy_car:Industry {id: 305, name: '新能源汽车', code: 'NEW_ENERGY_CAR', description: '新能源汽车产业'})

// =============================================
// 2. 创建人工智能行业的企业节点
// =============================================
CREATE (tencent:Company {id: 1001, name: '腾讯科技', industry: 'AI', description: '中国领先的互联网增值服务提供商'})
CREATE (alibaba:Company {id: 1002, name: '阿里巴巴', industry: 'AI', description: '全球领先的电子商务和云计算公司'})
CREATE (baidu:Company {id: 1003, name: '百度', industry: 'AI', description: '全球最大的中文搜索引擎和AI公司'})
CREATE (huawei:Company {id: 1004, name: '华为', industry: 'AI', description: '全球领先的ICT基础设施和智能终端提供商'})
CREATE (bytedance:Company {id: 1005, name: '字节跳动', industry: 'AI', description: '全球化的科技公司，拥有抖音、TikTok等产品'})
CREATE (xiaomi:Company {id: 1006, name: '小米科技', industry: 'AI', description: '以智能手机和AIoT为核心的科技公司'})
CREATE (megvii:Company {id: 1007, name: '旷视科技', industry: 'AI', description: '专注于计算机视觉的AI企业'})
CREATE (sensetime:Company {id: 1008, name: '商汤科技', industry: 'AI', description: '中国领先的AI视觉技术公司'})
CREATE (horizon:Company {id: 1009, name: '地平线', industry: 'AI', description: '专注于边缘人工智能芯片的公司'})
CREATE (cambricon:Company {id: 1010, name: '寒武纪', industry: 'AI', description: '专注于智能芯片研发的公司'})

// =============================================
// 3. 创建人工智能技术节点
// =============================================
CREATE (ml:Technology {id: 2001, name: '机器学习', type: 'AI技术'})
CREATE (dl:Technology {id: 2002, name: '深度学习', type: 'AI技术'})
CREATE (nlp:Technology {id: 2003, name: '自然语言处理', type: 'AI技术'})
CREATE (cv:Technology {id: 2004, name: '计算机视觉', type: 'AI技术'})
CREATE (speech:Technology {id: 2005, name: '语音识别', type: 'AI技术'})
CREATE (llm:Technology {id: 2006, name: '大语言模型', type: 'AI技术'})
CREATE (reinforcement:Technology {id: 2007, name: '强化学习', type: 'AI技术'})
CREATE (generative:Technology {id: 2008, name: '生成式AI', type: 'AI技术'})

// =============================================
// 4. 创建新能源汽车企业节点
// =============================================
CREATE (byd:Company {id: 3001, name: '比亚迪', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车领导者'})
CREATE (tesla:Company {id: 3002, name: '特斯拉', industry: 'NEW_ENERGY_CAR', description: '全球新能源汽车和清洁能源公司'})
CREATE (nio:Company {id: 3003, name: '蔚来', industry: 'NEW_ENERGY_CAR', description: '中国高端智能电动汽车品牌'})
CREATE (xiaopeng:Company {id: 3004, name: '小鹏', industry: 'NEW_ENERGY_CAR', description: '专注于智能网联电动汽车的公司'})
CREATE (li_auto:Company {id: 3005, name: '理想汽车', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车公司'})
CREATE (wm:Company {id: 3006, name: '威马汽车', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车企业'})
CREATE (leapmotor:Company {id: 3007, name: '零跑汽车', industry: 'NEW_ENERGY_CAR', description: '中国智能电动汽车公司'})
CREATE (hezhong:Company {id: 3008, name: '哪吒汽车', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车公司'})
CREATE (seres:Company {id: 3009, name: '赛力斯', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车企业'})
CREATE (deepal:Company {id: 3010, name: '深蓝汽车', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车品牌'})

// =============================================
// 5. 创建新能源汽车相关节点
// =============================================
CREATE (battery:Product {id: 4001, name: '动力电池', type: '汽车核心部件'})
CREATE (motor:Product {id: 4002, name: '驱动电机', type: '汽车核心部件'})
CREATE (bms:Product {id: 4003, name: '电池管理系统', type: '汽车核心部件'})
CREATE (adas:Product {id: 4004, name: '自动驾驶系统', type: '汽车核心部件'})
CREATE (chips:Material {id: 5001, name: '车规级芯片', type: '原材料'})
CREATE (lithium:Material {id: 5002, name: '锂', type: '原材料'})
CREATE (cobalt:Material {id: 5003, name: '钴', type: '原材料'})
CREATE (nickel:Material {id: 5004, name: '镍', type: '原材料'})

// =============================================
// 6. 创建人工智能行业关系
// =============================================
CREATE (tencent)-[:USES {weight: 0.9}]->(ml)
CREATE (tencent)-[:USES {weight: 0.85}]->(nlp)
CREATE (tencent)-[:USES {weight: 0.8}]->(speech)
CREATE (tencent)-[:COMPETES_WITH {weight: 0.8}]->(alibaba)
CREATE (tencent)-[:INVESTS_IN {weight: 0.7}]->(xiaomi)

CREATE (alibaba)-[:USES {weight: 0.9}]->(ml)
CREATE (alibaba)-[:USES {weight: 0.85}]->(cv)
CREATE (alibaba)-[:COMPETES_WITH {weight: 0.85}]->(tencent)
CREATE (alibaba)-[:PARTNERS_WITH {weight: 0.7}]->(baidu)

CREATE (baidu)-[:USES {weight: 0.95}]->(cv)
CREATE (baidu)-[:USES {weight: 0.9}]->(dl)
CREATE (baidu)-[:USES {weight: 0.85}]->(llm)
CREATE (baidu)-[:COMPETES_WITH {weight: 0.75}]->(megvii)
CREATE (baidu)-[:COMPETES_WITH {weight: 0.7}]->(sensetime)

CREATE (huawei)-[:USES {weight: 0.9}]->(dl)
CREATE (huawei)-[:USES {weight: 0.85}]->(reinforcement)
CREATE (huawei)-[:PARTNERS_WITH {weight: 0.7}]->(byd)

CREATE (bytedance)-[:USES {weight: 0.95}]->(ml)
CREATE (bytedance)-[:USES {weight: 0.9}]->(llm)
CREATE (bytedance)-[:USES {weight: 0.85}]->(generative)
CREATE (bytedance)-[:COMPETES_WITH {weight: 0.7}]->(tencent)

CREATE (megvii)-[:SPECIALIZES_IN {weight: 0.95}]->(cv)
CREATE (sensetime)-[:SPECIALIZES_IN {weight: 0.95}]->(cv)
CREATE (horizon)-[:PROVIDES {weight: 0.9}]->(chips)
CREATE (cambricon)-[:PROVIDES {weight: 0.9}]->(chips)

CREATE (ai)-[:INCLUDES {weight: 1.0}]->(tencent)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(alibaba)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(baidu)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(huawei)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(bytedance)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(xiaomi)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(megvii)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(sensetime)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(horizon)
CREATE (ai)-[:INCLUDES {weight: 1.0}]->(cambricon)

// =============================================
// 7. 创建新能源汽车行业关系
// =============================================
CREATE (byd)-[:PRODUCES {weight: 0.95}]->(battery)
CREATE (byd)-[:USES {weight: 0.9}]->(bms)
CREATE (byd)-[:USES {weight: 0.85}]->(adas)
CREATE (byd)-[:COMPETES_WITH {weight: 0.9}]->(tesla)
CREATE (byd)-[:COMPETES_WITH {weight: 0.85}]->(nio)
CREATE (byd)-[:COMPETES_WITH {weight: 0.8}]->(xiaopeng)
CREATE (byd)-[:USES {weight: 0.8}]->(lithium)
CREATE (byd)-[:USES {weight: 0.7}]->(cobalt)

CREATE (tesla)-[:USES {weight: 0.9}]->(battery)
CREATE (tesla)-[:USES {weight: 0.9}]->(motor)
CREATE (tesla)-[:USES {weight: 0.95}]->(adas)
CREATE (tesla)-[:COMPETES_WITH {weight: 0.9}]->(byd)
CREATE (tesla)-[:USES {weight: 0.85}]->(nickel)

CREATE (nio)-[:USES {weight: 0.9}]->(battery)
CREATE (nio)-[:COMPETES_WITH {weight: 0.85}]->(byd)
CREATE (nio)-[:COMPETES_WITH {weight: 0.8}]->(tesla)
CREATE (nio)-[:COMPETES_WITH {weight: 0.85}]->(xiaopeng)

CREATE (xiaopeng)-[:USES {weight: 0.9}]->(adas)
CREATE (xiaopeng)-[:COMPETES_WITH {weight: 0.85}]->(byd)
CREATE (xiaopeng)-[:COMPETES_WITH {weight: 0.8}]->(nio)

CREATE (li_auto)-[:COMPETES_WITH {weight: 0.8}]->(byd)
CREATE (wm)-[:COMPETES_WITH {weight: 0.7}]->(byd)
CREATE (leapmotor)-[:COMPETES_WITH {weight: 0.7}]->(byd)
CREATE (hezhong)-[:COMPETES_WITH {weight: 0.7}]->(byd)
CREATE (seres)-[:COMPETES_WITH {weight: 0.7}]->(byd)
CREATE (deepal)-[:COMPETES_WITH {weight: 0.7}]->(byd)

CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(byd)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(tesla)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(nio)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(xiaopeng)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(li_auto)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(wm)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(leapmotor)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(hezhong)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(seres)
CREATE (new_energy_car)-[:INCLUDES {weight: 1.0}]->(deepal)

// =============================================
// 初始化完成
// =============================================
