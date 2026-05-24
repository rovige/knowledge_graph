const LoginPage = {
  init() {
    this.bindEvents();
  },

  bindEvents() {
    document.getElementById('loginForm').addEventListener('submit', (e) => {
      e.preventDefault();
      this.handleLogin();
    });
  },

  async handleLogin() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (!username || !password) {
      Utils.showMessage('请输入用户名和密码', 'error');
      return;
    }

    try {
      console.log('[Login] 开始登录...', { username });
      const response = await Utils.api.post('/auth/login', {
        username,
        password
      });
      
      console.log('[Login] 登录响应:', response);

      if (response && (response.code === 200 || response.success)) {
        if (response.data) {
          const { token, userInfo } = response.data;
          
          Utils.storage.set('token', token);
          Utils.storage.set('user', userInfo);
          
          Utils.showMessage('登录成功', 'success');
          
          setTimeout(() => {
            window.location.href = '../main/main.html';
          }, 1000);
        } else {
          Utils.showMessage('登录响应数据为空', 'error');
        }
      } else {
        Utils.showMessage(response?.message || '登录失败', 'error');
      }
    } catch (error) {
      console.error('[Login] 登录错误:', error);
      Utils.showMessage('登录失败: ' + (error?.message || '未知错误'), 'error');
    }
  }
};

LoginPage.init();
