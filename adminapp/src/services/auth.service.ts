import axiosInstance from '../utils/axios';

interface AuthResponse {
  token: string;
  user: {
    id: string;
    username: string;
    email: string;
    role: string;
  };
}

class AuthService {
  async login(username: string, password: string): Promise<AuthResponse> {
    const response = await axiosInstance.post<AuthResponse>('/auth/login', {
      username,
      password,
    });
    if (response.data.token) {
      localStorage.setItem('user', JSON.stringify(response.data));
    }
    return response.data;
  }

  logout(): void {
    localStorage.removeItem('user');
  }

  getCurrentUser(): AuthResponse | null {
    const userStr = localStorage.getItem('user');
    if (userStr) return JSON.parse(userStr);
    return null;
  }

  getToken(): string | null {
    const user = this.getCurrentUser();
    return user?.token || null;
  }
}

const authService = new AuthService();
export default authService; 