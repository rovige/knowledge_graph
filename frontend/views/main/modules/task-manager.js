
const TaskManager = {
  tasks: [],
  currentTask: null,
  taskStartTime: null,
  pollInterval: null,
  totalRecords: 0,
  currentPage: 1,
  pageSize: 10,

  statusMap: {
    'PENDING': { text: '等待中', class: 'warning' },
    'RUNNING': { text: '运行中', class: 'info' },
    'COMPLETED': { text: '已完成', class: 'success' },
    'FAILED': { text: '失败', class: 'danger' },
    'CANCELLED': { text: '已取消', class: 'secondary' }
  },

  async generateIndustryData(industry) {
    try {
      Utils.showMessage('开始生成数据...', 'info');
      const response = await Utils.api.post('/kg/tasks/generate', {
        industryId: industry.id,
        industryName: industry.name
      });
      if (response.code === 200 || response.success) {
        this.currentTask = response.data;
        this.taskStartTime = Date.now();
        this.showProgressModal(industry.name);
        this.startPolling();
      }
    } catch (error) {
      console.error('生成数据失败:', error);
      Utils.showMessage('生成数据失败', 'error');
    }
  },

  showProgressModal(industryName) {
    const modal = document.getElementById('progressModalOverlay');
    document.getElementById('progressIndustryName').textContent = `行业: ${industryName}`;
    document.getElementById('progressStep').textContent = '准备中...';
    document.getElementById('progressBar').style.width = '0%';
    document.getElementById('progressText').textContent = '0%';
    document.getElementById('progressEstimate').textContent = '预估时间: 计算中...';
    modal.style.display = 'flex';
  },

  hideProgressModal() {
    const modal = document.getElementById('progressModalOverlay');
    modal.style.display = 'none';
    this.stopPolling();
  },

  getStepText(progress) {
    if (progress < 10) return '初始化任务...';
    if (progress < 40) return '生成企业数据...';
    if (progress < 70) return '生成新闻数据...';
    if (progress < 100) return '生成知识图谱...';
    return '完成！';
  },

  updateProgressModal(task) {
    const progress = task.progress || 0;

    document.getElementById('progressStep').textContent = this.getStepText(progress);
    document.getElementById('progressBar').style.width = `${progress}%`;
    document.getElementById('progressText').textContent = `${progress}%`;

    if (progress > 0 && progress < 100 && this.taskStartTime) {
      const elapsed = (Date.now() - this.taskStartTime) / 1000;
      const estimatedTotal = (elapsed / progress) * 100;
      const remaining = Math.max(0, estimatedTotal - elapsed);
      document.getElementById('progressEstimate').textContent =
        `预估剩余: ${Math.round(remaining)}秒`;
    } else if (progress === 100) {
      const elapsed = ((Date.now() - this.taskStartTime) / 1000).toFixed(1);
      document.getElementById('progressEstimate').textContent = `耗时: ${elapsed}秒`;
    }
  },

  startPolling() {
    if (this.pollInterval) {
      clearInterval(this.pollInterval);
    }

    const poll = async () => {
      try {
        const response = await Utils.api.get(`/kg/tasks/${this.currentTask.id}`);
        if (response.code === 200 || response.success) {
          this.currentTask = response.data;
          this.updateProgressModal(this.currentTask);

          if (this.currentTask.status === 'COMPLETED') {
            setTimeout(() => {
              this.hideProgressModal();
              Utils.showMessage('数据生成完成！', 'success');
              if (window.MainApp && window.MainApp.loadGraphData) {
                window.MainApp.loadGraphData(this.currentTask.industryId);
              }
            }, 1000);
            this.stopPolling();
          } else if (this.currentTask.status === 'FAILED') {
            this.hideProgressModal();
            Utils.showMessage('数据生成失败: ' + this.currentTask.errorMessage, 'error');
            this.stopPolling();
          } else if (this.currentTask.status === 'CANCELLED') {
            this.hideProgressModal();
            Utils.showMessage('任务已取消', 'info');
            this.stopPolling();
          }
        }
      } catch (error) {
        console.error('查询任务状态失败:', error);
      }
    };

    this.pollInterval = setInterval(poll, 500);
    poll();
  },

  stopPolling() {
    if (this.pollInterval) {
      clearInterval(this.pollInterval);
      this.pollInterval = null;
    }
  },

  async loadTasks(page = 1) {
    try {
      this.currentPage = page;
      const response = await Utils.api.get('/kg/tasks', {
        current: page,
        size: this.pageSize
      });
      
      console.log('[TaskManager] 加载任务列表响应:', response);
      
      if (response && (response.code === 200 || response.success)) {
        if (response.data) {
          this.tasks = response.data.records || response.data || [];
          this.totalRecords = response.data.total || (Array.isArray(this.tasks) ? this.tasks.length : 0);
        } else {
          this.tasks = [];
          this.totalRecords = 0;
        }
        this.renderTasks();
      } else {
        this.tasks = [];
        this.totalRecords = 0;
        this.renderTasks();
      }
    } catch (error) {
      console.error('加载任务列表失败:', error);
      this.tasks = [];
      this.totalRecords = 0;
      this.renderTasks();
    }
  },

  renderTasks() {
    const container = document.getElementById('taskList');
    if (!container) return;

    container.innerHTML = this.tasks.map(task => {
      const statusInfo = this.statusMap[task.status] || { text: '未知', class: '' };
      const duration = task.startTime && task.endTime
        ? `${Math.round((new Date(task.endTime) - new Date(task.startTime)) / 1000)}秒`
        : '-';

      return `
        <div class="task-item">
          <div class="task-header">
            <div class="task-name">${task.industryName}</div>
            <span class="task-badge badge-${statusInfo.class}">${statusInfo.text}</span>
          </div>
          <div class="task-info">
            <span>任务ID: ${task.id}</span>
            <span>进度: ${task.progress}%</span>
            <span>类型: ${task.taskType}</span>
          </div>
          <div class="task-info">
            <span>开始时间: ${task.startTime ? new Date(task.startTime).toLocaleString() : '-'}</span>
          </div>
          <div class="task-info">
            <span>结束时间: ${task.endTime ? new Date(task.endTime).toLocaleString() : '-'}</span>
            <span>耗时: ${duration}</span>
          </div>
          ${task.errorMessage ? `<div class="task-error">错误: ${task.errorMessage}</div>` : ''}
          <div class="task-actions">
            ${(task.status === 'PENDING' || task.status === 'RUNNING') ? 
              `<button class="btn btn-sm btn-warning" onclick="TaskManager.cancelTask(${task.id})">取消</button>` : ''
            }
            <button class="btn btn-sm btn-danger" onclick="TaskManager.deleteTask(${task.id})">删除</button>
          </div>
        </div>
      `;
    }).join('');

    this.renderPagination();
  },

  renderPagination() {
    const container = document.getElementById('taskPagination');
    if (!container) return;

    const totalPages = Math.ceil(this.totalRecords / this.pageSize);
    if (totalPages <= 1) {
      container.innerHTML = '';
      return;
    }

    let paginationHtml = `
      <button class="btn btn-sm btn-default" 
        onclick="TaskManager.loadTasks(${Math.max(1, this.currentPage - 1)})" 
        ${this.currentPage <= 1 ? 'disabled' : ''}>
        上一页
      </button>
      <span class="page-info">第 ${this.currentPage} / ${totalPages} 页</span>
      <button class="btn btn-sm btn-default" 
        onclick="TaskManager.loadTasks(${Math.min(totalPages, this.currentPage + 1)})" 
        ${this.currentPage >= totalPages ? 'disabled' : ''}>
        下一页
      </button>
    `;
    container.innerHTML = paginationHtml;
  },

  async cancelTask(taskId) {
    if (!window.confirm('确定要取消此任务吗？')) return;
    
    try {
      const response = await Utils.api.post(`/kg/tasks/${taskId}/cancel`);
      if (response.code === 200 || response.success) {
        Utils.showMessage('任务已取消', 'success');
        this.loadTasks(this.currentPage);
      }
    } catch (error) {
      console.error('取消任务失败:', error);
      Utils.showMessage('取消任务失败', 'error');
    }
  },

  async deleteTask(taskId) {
    if (!window.confirm('确定要删除此任务记录吗？')) return;
    
    try {
      await Utils.api.delete(`/kg/tasks/${taskId}`);
      Utils.showMessage('删除成功', 'success');
      this.loadTasks(this.currentPage);
    } catch (error) {
      console.error('删除任务失败:', error);
      Utils.showMessage('删除任务失败', 'error');
    }
  }
};
