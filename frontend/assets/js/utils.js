const Utils = {
  storage: {
    set(key, value) {
      localStorage.setItem(key, JSON.stringify(value));
    },
    get(key) {
      const value = localStorage.getItem(key);
      try {
        return value ? JSON.parse(value) : null;
      } catch {
        return value;
      }
    },
    remove(key) {
      localStorage.removeItem(key);
    }
  },

  api: {
    baseUrl: 'http://localhost:8080',
    
    async request(url, options = {}) {
      const token = Utils.storage.get('token');
      const headers = {
        'Content-Type': 'application/json',
        ...options.headers
      };
      if (token) {
        headers['Authorization'] = `Bearer ${token}`;
      }
      
      console.log(`[API Request] ${options.method || 'GET'} ${this.baseUrl}${url}`);
      console.log('[API Token]', token ? '已设置' : '未设置');
      
      try {
        const response = await fetch(`${this.baseUrl}${url}`, {
          ...options,
          headers
        });
        
        console.log(`[API Response Status] ${response.status}`);
        
        if (response.status === 401) {
          Utils.storage.remove('token');
          Utils.storage.remove('user');
          window.location.href = '../login/login.html';
          return;
        }
        
        // 先获取响应文本
        const responseText = await response.text();
        console.log('[API Response Text]', responseText || '(空响应)');
        
        // 如果响应为空，返回成功
        if (!responseText) {
          console.log('[API] 空响应被视为成功');
          return { code: 200, success: true };
        }
        
        // 尝试解析 JSON
        let data;
        try {
          data = JSON.parse(responseText);
          console.log('[API Parsed Data]', data);
        } catch (e) {
          throw new Error(`无效的 JSON 响应: ${responseText.substring(0, 100)}`);
        }
        
        return data;
      } catch (error) {
        console.error('API 请求失败:', error);
        Utils.showMessage(`网络请求失败: ${error.message}`, 'error');
        throw error;
      }
    },

    async get(url, params = {}) {
      const queryString = new URLSearchParams(params).toString();
      const fullUrl = queryString ? `${url}?${queryString}` : url;
      return this.request(fullUrl, { method: 'GET' });
    },

    async post(url, data = {}) {
      return this.request(url, {
        method: 'POST',
        body: JSON.stringify(data)
      });
    },

    async put(url, data = {}) {
      return this.request(url, {
        method: 'PUT',
        body: JSON.stringify(data)
      });
    },

    async delete(url) {
      return this.request(url, { method: 'DELETE' });
    }
  },

  generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  },

  formatDate(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    const hour = String(d.getHours()).padStart(2, '0');
    const minute = String(d.getMinutes()).padStart(2, '0');
    const second = String(d.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
  },

  showMessage(text, type = 'info') {
    const colors = {
      success: '#52c41a',
      error: '#ff4d4f',
      warning: '#faad14',
      info: '#1890ff'
    };
    const el = document.createElement('div');
    el.style.cssText = `
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%);
      padding: 12px 24px;
      background: ${colors[type]};
      color: #fff;
      border-radius: 4px;
      z-index: 9999;
      animation: fadeIn 0.3s;
    `;
    el.textContent = text;
    document.body.appendChild(el);
    setTimeout(() => {
      el.style.animation = 'fadeOut 0.3s';
      setTimeout(() => el.remove(), 300);
    }, 3000);
  },

  confirm(text) {
    return new Promise((resolve) => {
      resolve(window.confirm(text));
    });
  }
};

const style = document.createElement('style');
style.textContent = `
  @keyframes fadeIn {
    from { opacity: 0; transform: translateX(-50%) translateY(-20px); }
    to { opacity: 1; transform: translateX(-50%) translateY(0); }
  }
  @keyframes fadeOut {
    from { opacity: 1; }
    to { opacity: 0; }
  }
`;
document.head.appendChild(style);
