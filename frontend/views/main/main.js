const MainApp = {
  industries: [],
  currentIndustry: null,
  isMaximized: false,

  pageSize: 10,
  currentPage: {
    user: 1,
    role: 1,
    permission: 1,
    menu: 1,
    industry: 1,
    entity: 1,
    relation: 1
  },

  menuTitles: {
    user: '用户管理',
    role: '角色管理',
    permission: '权限管理',
    menu: '菜单管理',
    industry: '行业管理',
    entity: '实体管理',
    relation: '关系管理',
    task: '任务管理'
  },

  users: [],
  roles: [],
  permissions: [],
  menus: [],
  industriesData: [],
  entities: [],
  relations: [],

  totalRecords: {
    user: 0,
    role: 0,
    permission: 0,
    menu: 0,
    industry: 0,
    entity: 0,
    relation: 0
  },

  currentEditItem: null,
  currentEditType: null,
  isEditModalOpen: false,

  async init() {
    this.checkLogin();
    this.renderUserInfo();
    
    // 初始化图谱模块
    GraphCore.init('graphContainer');
    
    this.bindEvents();
    await this.loadAllData();
    this.renderSystemPages();
    
    // 暴露到全局供其他模块调用
    window.MainApp = this;
  },

  checkLogin() {
    const user = Utils.storage.get('user');
    if (!user) {
      window.location.href = '../login/login.html';
    }
  },

  renderUserInfo() {
    const user = Utils.storage.get('user');
    document.getElementById('userInfo').textContent = `欢迎，${user?.name || '用户'}`;
  },

  async loadAllData() {
    await Promise.all([
      this.loadIndustries(),
      this.loadUsers(),
      this.loadRoles(),
      this.loadPermissions(),
      this.loadMenus()
    ]);
    this.renderIndustryList();
  },

  async loadIndustries() {
    try {
      console.log('开始加载行业数据...');
      // 系统管理页面使用所有行业（包含 hasData 标志）
      const allResponse = await Utils.api.get('/industries/all');
      if (allResponse.code === 200 || allResponse.success) {
        this.industriesData = allResponse.data || [];
        this.totalRecords.industry = this.industriesData.length;
        console.log('系统管理行业数据:', this.industriesData.length);
      }

      // 知识图谱页面只显示有数据的行业
      const withDataResponse = await Utils.api.get('/industries/with-data');
      console.log('有数据的行业响应:', withDataResponse);
      if (withDataResponse.code === 200 || withDataResponse.success) {
        this.industries = withDataResponse.data || [];
        console.log('有数据的行业列表:', this.industries);
        if (this.industries.length > 0) {
          this.currentIndustry = this.industries[0];
          console.log('选中当前行业:', this.currentIndustry);
        }
      }
      
      // 渲染行业列表并加载知识图谱
      this.renderIndustryList();
      if (this.currentIndustry && this.currentIndustry.id) {
        console.log('加载知识图谱数据...');
        await this.loadGraphData(this.currentIndustry.id);
      }
    } catch (error) {
      console.error('加载行业数据失败:', error);
    }
  },

  async loadUsers() {
    try {
      const response = await Utils.api.get('/users', {
        current: this.currentPage.user,
        size: this.pageSize
      });
      if (response.code === 200 || response.success) {
        this.users = response.data?.records || response.data || [];
        this.totalRecords.user = response.data?.total || this.users.length;
      }
    } catch (error) {
      console.error('加载用户数据失败:', error);
    }
  },

  async loadRoles() {
    try {
      const response = await Utils.api.get('/roles', {
        current: this.currentPage.role,
        size: this.pageSize
      });
      if (response.code === 200 || response.success) {
        this.roles = response.data?.records || response.data || [];
        this.totalRecords.role = response.data?.total || this.roles.length;
      }
    } catch (error) {
      console.error('加载角色数据失败:', error);
    }
  },

  async loadPermissions() {
    try {
      const response = await Utils.api.get('/permissions', {
        current: this.currentPage.permission,
        size: this.pageSize
      });
      if (response.code === 200 || response.success) {
        this.permissions = response.data?.records || response.data || [];
        this.totalRecords.permission = response.data?.total || this.permissions.length;
      }
    } catch (error) {
      console.error('加载权限数据失败:', error);
    }
  },

  async loadMenus() {
    try {
      const response = await Utils.api.get('/menus', {
        current: this.currentPage.menu,
        size: this.pageSize
      });
      if (response.code === 200 || response.success) {
        this.menus = response.data?.records || response.data || [];
        this.totalRecords.menu = response.data?.total || this.menus.length;
      }
    } catch (error) {
      console.error('加载菜单数据失败:', error);
    }
  },

  async loadEntities() {
    try {
      const response = await Utils.api.get('/kg/entities', {
        current: this.currentPage.entity,
        size: this.pageSize
      });
      if (response.code === 200 || response.success) {
        this.entities = response.data?.records || response.data || [];
        this.totalRecords.entity = response.data?.total || this.entities.length;
      }
    } catch (error) {
      console.error('加载实体数据失败:', error);
    }
  },

  async loadRelations() {
    try {
      const response = await Utils.api.get('/kg/relations', {
        current: this.currentPage.relation,
        size: this.pageSize
      });
      if (response.code === 200 || response.success) {
        this.relations = response.data?.records || response.data || [];
        this.totalRecords.relation = response.data?.total || this.relations.length;
      }
    } catch (error) {
      console.error('加载关系数据失败:', error);
    }
  },

  async loadGraphData(industryId) {
    try {
      const response = await Utils.api.get(`/kg/graph/${industryId}`);
      if (response.code === 200 || response.success) {
        const graphData = response.data || { nodes: [], edges: [] };
        GraphCore.renderChart(graphData, (node) => this.handleNodeClick(node));
        await CompanyManager.loadCompanies(industryId);
      }
    } catch (error) {
      console.error('加载图谱数据失败:', error);
    }
  },

  handleNodeClick(node) {
    if (node.type === 'COMPANY') {
      const company = CompanyManager.companies.find(c => c.name === node.name);
      if (company) {
        CompanyManager.selectCompany(company.id);
      }
    }
  },

  renderIndustryList() {
    const container = document.getElementById('industryList');
    container.innerHTML = this.industries.map(item => `
      <div class="industry-item ${this.currentIndustry?.id === item.id ? 'active' : ''}" data-id="${item.id}">
        <div class="industry-name">${item.name}</div>
        <button class="generate-btn" data-id="${item.id}" data-name="${item.name}">生成数据</button>
      </div>
    `).join('');
  },

  renderSystemPages() {
    this.renderUserManagement();
    this.renderRoleManagement();
    this.renderPermissionManagement();
    this.renderMenuManagement();
    this.renderIndustryManagement();
    this.renderEntityManagement();
    this.renderRelationManagement();
    this.renderTaskManagement();
  },

  renderUserManagement() {
    const panel = document.getElementById('panelUser');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('user')">添加用户</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>用户名</th><th>昵称</th><th>邮箱</th><th>状态</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.users.map(u => `
            <tr>
              <td>${u.id}</td>
              <td>${u.username}</td>
              <td>${u.nickname || '-'}</td>
              <td>${u.email || '-'}</td>
              <td><span class="status-badge ${u.status === 1 ? 'active' : 'inactive'}">${u.status === 1 ? '启用' : '禁用'}</span></td>
              <td>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('user', ${u.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('user', ${u.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderRoleManagement() {
    const panel = document.getElementById('panelRole');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('role')">添加角色</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>角色名称</th><th>角色编码</th><th>状态</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.roles.map(r => `
            <tr>
              <td>${r.id}</td>
              <td>${r.name}</td>
              <td>${r.code}</td>
              <td><span class="status-badge ${r.status === 1 ? 'active' : 'inactive'}">${r.status === 1 ? '启用' : '禁用'}</span></td>
              <td>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('role', ${r.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('role', ${r.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderPermissionManagement() {
    const panel = document.getElementById('panelPermission');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('permission')">添加权限</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>权限名称</th><th>权限编码</th><th>类型</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.permissions.map(p => `
            <tr>
              <td>${p.id}</td>
              <td>${p.name}</td>
              <td>${p.code}</td>
              <td>${p.type || '-'}</td>
              <td>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('permission', ${p.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('permission', ${p.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderMenuManagement() {
    const panel = document.getElementById('panelMenu');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('menu')">添加菜单</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>菜单名称</th><th>路由</th><th>排序</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.menus.map(m => `
            <tr>
              <td>${m.id}</td>
              <td>${m.name}</td>
              <td>${m.path || '-'}</td>
              <td>${m.sort || 0}</td>
              <td>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('menu', ${m.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('menu', ${m.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderIndustryManagement() {
    const panel = document.getElementById('panelIndustry');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('industry')">添加行业</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>行业名称</th><th>行业编码</th><th>排序</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.industriesData.map(i => `
            <tr>
              <td>${i.id}</td>
              <td>${i.name}</td>
              <td>${i.code}</td>
              <td>${i.sort || 0}</td>
              <td>
                <button class="btn btn-sm ${i.hasData ? 'btn-info' : 'btn-primary'}" onclick="TaskManager.generateIndustryData(${JSON.stringify(i).replace(/"/g, '&quot;')})">${i.hasData ? '重新生成数据' : '生成数据'}</button>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('industry', ${i.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('industry', ${i.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderEntityManagement() {
    const panel = document.getElementById('panelEntity');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('entity')">添加实体</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>实体名称</th><th>实体类型</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.entities.map(e => `
            <tr>
              <td>${e.id}</td>
              <td>${e.name}</td>
              <td>${e.type || '-'}</td>
              <td>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('entity', ${e.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('entity', ${e.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderRelationManagement() {
    const panel = document.getElementById('panelRelation');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="MainApp.openAddModal('relation')">添加关系</button>
      </div>
      <table class="data-table">
        <thead>
          <tr><th>ID</th><th>关系类型</th><th>源节点</th><th>目标节点</th><th>操作</th></tr>
        </thead>
        <tbody>
          ${this.relations.map(r => `
            <tr>
              <td>${r.id}</td>
              <td>${r.relationType || '-'}</td>
              <td>${r.sourceNodeId}</td>
              <td>${r.targetNodeId}</td>
              <td>
                <button class="btn btn-sm btn-primary" onclick="MainApp.openEditModal('relation', ${r.id})">编辑</button>
                <button class="btn btn-sm btn-danger" onclick="MainApp.deleteItem('relation', ${r.id})">删除</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    `;
  },

  renderTaskManagement() {
    const panel = document.getElementById('panelTask');
    if (!panel) return;
    
    panel.innerHTML = `
      <div class="page-header">
        <button class="btn btn-primary" onclick="TaskManager.loadTasks(1)">刷新列表</button>
      </div>
      <div id="taskList"></div>
      <div id="taskPagination"></div>
    `;
    
    // 加载任务列表
    TaskManager.loadTasks(1);
  },

  openAddModal(type) {
    this.currentEditType = type;
    this.currentEditItem = null;
    this.showEditModal();
  },

  openEditModal(type, id) {
    this.currentEditType = type;
    const dataMap = {
      user: this.users,
      role: this.roles,
      permission: this.permissions,
      menu: this.menus,
      industry: this.industriesData,
      entity: this.entities,
      relation: this.relations
    };
    this.currentEditItem = dataMap[type]?.find(item => item.id === id);
    this.showEditModal();
  },

  showEditModal() {
    const overlay = document.getElementById('editModalOverlay');
    const title = document.getElementById('editModalTitle');
    const form = document.getElementById('editModalForm');
    
    title.textContent = this.currentEditItem ? '编辑' + this.menuTitles[this.currentEditType] : '添加' + this.menuTitles[this.currentEditType];
    form.innerHTML = this.getFormFields();
    
    overlay.style.display = 'flex';
    this.isEditModalOpen = true;
  },

  getFormFields() {
    const item = this.currentEditItem || {};
    
    switch (this.currentEditType) {
      case 'user':
        return `
          <div class="form-group">
            <label>用户名</label>
            <input type="text" name="username" value="${item.username || ''}" placeholder="请输入用户名">
          </div>
          <div class="form-group">
            <label>昵称</label>
            <input type="text" name="nickname" value="${item.nickname || ''}" placeholder="请输入昵称">
          </div>
          <div class="form-group">
            <label>邮箱</label>
            <input type="email" name="email" value="${item.email || ''}" placeholder="请输入邮箱">
          </div>
          ${!this.currentEditItem ? `
            <div class="form-group">
              <label>密码</label>
              <input type="password" name="password" placeholder="请输入密码">
            </div>
          ` : ''}
        `;
      case 'industry':
        return `
          <div class="form-group">
            <label>行业名称</label>
            <input type="text" name="name" value="${item.name || ''}" placeholder="请输入行业名称">
          </div>
          <div class="form-group">
            <label>行业编码</label>
            <input type="text" name="code" value="${item.code || ''}" placeholder="请输入行业编码">
          </div>
          <div class="form-group">
            <label>父行业ID</label>
            <input type="number" name="parentId" value="${item.parentId || 0}" placeholder="父行业ID，0表示一级">
          </div>
        `;
      case 'entity':
        return `
          <div class="form-group">
            <label>实体名称</label>
            <input type="text" name="name" value="${item.name || ''}" placeholder="请输入实体名称">
          </div>
          <div class="form-group">
            <label>实体类型</label>
            <select name="type">
              <option value="INDUSTRY" ${item.type === 'INDUSTRY' ? 'selected' : ''}>行业</option>
              <option value="COMPANY" ${item.type === 'COMPANY' ? 'selected' : ''}>企业</option>
            </select>
          </div>
        `;
      case 'relation':
        return `
          <div class="form-group">
            <label>源节点ID</label>
            <input type="number" name="sourceNodeId" value="${item.sourceNodeId || ''}" placeholder="请输入源节点ID">
          </div>
          <div class="form-group">
            <label>目标节点ID</label>
            <input type="number" name="targetNodeId" value="${item.targetNodeId || ''}" placeholder="请输入目标节点ID">
          </div>
          <div class="form-group">
            <label>关系类型</label>
            <select name="relationType">
              <option value="INCLUDES" ${item.relationType === 'INCLUDES' ? 'selected' : ''}>包含</option>
              <option value="SUPPLIES_TO" ${item.relationType === 'SUPPLIES_TO' ? 'selected' : ''}>供应</option>
              <option value="COOPERATES_WITH" ${item.relationType === 'COOPERATES_WITH' ? 'selected' : ''}>合作</option>
            </select>
          </div>
        `;
      default:
        return `
          <div class="form-group">
            <label>名称</label>
            <input type="text" name="name" value="${item.name || ''}" placeholder="请输入名称">
          </div>
        `;
    }
  },

  hideEditModal() {
    document.getElementById('editModalOverlay').style.display = 'none';
    this.isEditModalOpen = false;
  },

  async saveItem() {
    const form = document.getElementById('editModalForm');
    const formData = new FormData(form.querySelector('form') || form);
    const data = {};
    formData.forEach((value, key) => {
      data[key] = value;
    });

    try {
      const apiMap = {
        user: { get: '/users', post: '/users', put: (id) => `/users/${id}`, del: (id) => `/users/${id}` },
        role: { get: '/roles', post: '/roles', put: (id) => `/roles/${id}`, del: (id) => `/roles/${id}` },
        permission: { get: '/permissions', post: '/permissions', put: (id) => `/permissions/${id}`, del: (id) => `/permissions/${id}` },
        menu: { get: '/menus', post: '/menus', put: (id) => `/menus/${id}`, del: (id) => `/menus/${id}` },
        industry: { get: '/industries', post: '/industries', put: (id) => `/industries/${id}`, del: (id) => `/industries/${id}` },
        entity: { get: '/kg/entities', post: '/kg/entities', put: (id) => `/kg/entities/${id}`, del: (id) => `/kg/entities/${id}` },
        relation: { get: '/kg/relations', post: '/kg/relations', put: (id) => `/kg/relations/${id}`, del: (id) => `/kg/relations/${id}` }
      };

      const api = apiMap[this.currentEditType];
      
      if (this.currentEditItem) {
        await Utils.api.put(api.put(this.currentEditItem.id), data);
      } else {
        await Utils.api.post(api.post, data);
      }

      Utils.showMessage('保存成功', 'success');
      this.hideEditModal();
      await this.loadAllData();
      this.renderSystemPages();
    } catch (error) {
      console.error('保存失败:', error);
      Utils.showMessage('保存失败', 'error');
    }
  },

  async deleteItem(type, id) {
    if (!window.confirm('确定要删除吗？')) return;

    try {
      const apiMap = {
        user: (id) => `/users/${id}`,
        role: (id) => `/roles/${id}`,
        permission: (id) => `/permissions/${id}`,
        menu: (id) => `/menus/${id}`,
        industry: (id) => `/industries/${id}`,
        entity: (id) => `/kg/entities/${id}`,
        relation: (id) => `/kg/relations/${id}`
      };

      await Utils.api.delete(apiMap[type](id));
      Utils.showMessage('删除成功', 'success');
      await this.loadAllData();
      this.renderSystemPages();
    } catch (error) {
      console.error('删除失败:', error);
      Utils.showMessage('删除失败', 'error');
    }
  },

  bindEvents() {
    // 导航菜单
    document.querySelector('.header-nav').addEventListener('click', (e) => {
      const navItem = e.target.closest('.nav-item');
      if (!navItem) return;

      const page = navItem.dataset.page;
      document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
      navItem.classList.add('active');

      document.querySelectorAll('.content > div').forEach(p => p.classList.remove('active'));
      document.getElementById(`page${page.charAt(0).toUpperCase() + page.slice(1)}`).classList.add('active');
    });

    // 行业列表点击
    document.getElementById('industryList').addEventListener('click', (e) => {
      const generateBtn = e.target.closest('.generate-btn');
      if (generateBtn) {
        e.stopPropagation();
        const id = parseInt(generateBtn.dataset.id);
        const name = generateBtn.dataset.name;
        TaskManager.generateIndustryData({ id, name });
        return;
      }

      const industryItem = e.target.closest('.industry-item');
      if (!industryItem) return;

      const id = parseInt(industryItem.dataset.id);
      const industry = this.industries.find(i => i.id === id);
      if (industry) {
        this.currentIndustry = industry;
        this.renderIndustryList();
        this.loadGraphData(id);
      }
    });

    // 系统菜单切换
    document.getElementById('systemMenu').addEventListener('click', (e) => {
      const menuItem = e.target.closest('.menu-item');
      if (!menuItem) return;

      const tab = menuItem.dataset.tab;
      document.querySelectorAll('.menu-item').forEach(item => item.classList.remove('active'));
      menuItem.classList.add('active');

      document.getElementById('contentHeader').querySelector('.content-title').textContent = this.menuTitles[tab];

      document.querySelectorAll('.content-body .panel').forEach(panel => panel.classList.remove('active'));
      document.getElementById(`panel${tab.charAt(0).toUpperCase() + tab.slice(1)}`).classList.add('active');

      if (tab === 'entity') this.loadEntities().then(() => this.renderEntityManagement());
      if (tab === 'relation') this.loadRelations().then(() => this.renderRelationManagement());
      if (tab === 'task') TaskManager.loadTasks(1);
    });

    // 编辑弹窗按钮
    document.getElementById('editModalClose').addEventListener('click', () => this.hideEditModal());
    document.getElementById('editModalCancel').addEventListener('click', () => this.hideEditModal());
    document.getElementById('editModalSave').addEventListener('click', () => this.saveItem());

    document.getElementById('editModalOverlay').addEventListener('click', (e) => {
      if (e.target.id === 'editModalOverlay') this.hideEditModal();
    });

    // 退出按钮
    document.getElementById('logoutBtn').addEventListener('click', () => {
      Utils.storage.remove('token');
      Utils.storage.remove('user');
      window.location.href = '../login/login.html';
    });

    // 图谱控制按钮
    document.getElementById('zoomInBtn')?.addEventListener('click', () => GraphCore.zoomIn());
    document.getElementById('zoomOutBtn')?.addEventListener('click', () => GraphCore.zoomOut());
    document.getElementById('resetZoomBtn')?.addEventListener('click', () => GraphCore.resetZoom());
    document.getElementById('maximizeBtn')?.addEventListener('click', () => {
      this.isMaximized = !this.isMaximized;
      const container = document.querySelector('.page-graph');
      container.classList.toggle('maximized', this.isMaximized);
      GraphCore.resize();
    });
  }
};

document.addEventListener('DOMContentLoaded', () => {
  MainApp.init();
});
