
const CompanyManager = {
  companies: [],
  currentCompany: null,
  news: [],

  async loadCompanies(industryId) {
    try {
      const response = await Utils.api.get(`/kg/companies/${industryId}`);
      if (response.code === 200 || response.success) {
        this.companies = response.data || [];
        this.renderCompanyList();
      }
    } catch (error) {
      console.error('加载企业数据失败:', error);
    }
  },

  renderCompanyList() {
    const container = document.getElementById('companyList');
    if (!container) return;

    container.innerHTML = this.companies.map(company => `
      <div class="company-item" data-id="${company.id}" onclick="CompanyManager.selectCompany(${company.id})">
        <div class="company-rank">${company.ranking}</div>
        <div class="company-info">
          <div class="company-name">${company.name}</div>
          <div class="company-legal">法人: ${company.legalRepresentative || '-'}</div>
        </div>
      </div>
    `).join('');
  },

  async selectCompany(companyId) {
    this.currentCompany = this.companies.find(c => c.id === companyId);
    if (this.currentCompany) {
      await this.loadNews(companyId);
      this.renderCompanyDetail();
    }
  },

  async loadNews(companyId) {
    try {
      const response = await Utils.api.get(`/kg/news/${companyId}`);
      if (response.code === 200 || response.success) {
        this.news = response.data || [];
      }
    } catch (error) {
      console.error('加载新闻数据失败:', error);
    }
  },

  renderCompanyDetail() {
    const panel = document.getElementById('propertyPanel');
    if (!panel || !this.currentCompany) return;

    panel.innerHTML = `
      <div class="detail-section">
        <h4>企业信息</h4>
        <div class="detail-item"><span class="label">企业名称:</span> <span class="value">${this.currentCompany.name}</span></div>
        <div class="detail-item"><span class="label">法人代表:</span> <span class="value">${this.currentCompany.legalRepresentative || '-'}</span></div>
        <div class="detail-item"><span class="label">企业编码:</span> <span class="value">${this.currentCompany.code || '-'}</span></div>
        <div class="detail-item"><span class="label">地址:</span> <span class="value">${this.currentCompany.address || '-'}</span></div>
        <div class="detail-item"><span class="label">注册资本:</span> <span class="value">${this.currentCompany.registeredCapital ? (this.currentCompany.registeredCapital + ' 元') : '-'}</span></div>
        <div class="detail-item"><span class="label">成立日期:</span> <span class="value">${this.currentCompany.establishmentDate ? new Date(this.currentCompany.establishmentDate).toLocaleDateString() : '-'}</span></div>
        <div class="detail-item"><span class="label">行业排名:</span> <span class="value">第 ${this.currentCompany.ranking} 名</span></div>
        <div class="detail-item"><span class="label">经营范围:</span> <span class="value">${this.currentCompany.businessScope || '-'}</span></div>
      </div>
      
      <div class="detail-section">
        <h4>最新新闻</h4>
        ${this.news.length === 0 ? '<div class="empty-tip">暂无新闻</div>' :
          this.news.map(newsItem => `
            <div class="news-item">
              <div class="news-title">${newsItem.title}</div>
              <div class="news-meta">
                <span>${newsItem.source || '未知来源'}</span>
                <span>${newsItem.publishTime ? new Date(newsItem.publishTime).toLocaleString() : ''}</span>
              </div>
              <div class="news-summary">${newsItem.summary || ''}</div>
              ${newsItem.url ? `<a href="${newsItem.url}" target="_blank" class="news-link">查看原文</a>` : ''}
            </div>
          `).join('')
        }
      </div>
    `;
  }
};
