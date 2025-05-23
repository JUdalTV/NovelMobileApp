import axiosInstance from '../../utils/axios';
import { User } from '../../domain/entities/User';
import { UserRepository } from '../../domain/repositories/UserRepository';

export class UserRepositoryImpl implements UserRepository {
  async getUsers(): Promise<User[]> {
    const response = await axiosInstance.get<User[]>('/users');
    return response.data;
  }

  async getUserById(id: string): Promise<User> {
    const response = await axiosInstance.get<User>(`/users/${id}`);
    return response.data;
  }

  async createUser(user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>): Promise<User> {
    const response = await axiosInstance.post<User>('/users', user);
    return response.data;
  }

  async updateUser(id: string, user: Partial<User>): Promise<User> {
    const response = await axiosInstance.put<User>(`/users/${id}`, user);
    return response.data;
  }

  async deleteUser(id: string): Promise<void> {
    await axiosInstance.delete(`/users/${id}`);
  }
} 