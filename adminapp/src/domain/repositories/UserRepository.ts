import { User } from '../entities/User';

export interface UserRepository {
  getUsers(): Promise<User[]>;
  getUserById(id: string): Promise<User>;
  createUser(user: Omit<User, 'id' | 'createdAt' | 'updatedAt'>): Promise<User>;
  updateUser(id: string, user: Partial<User>): Promise<User>;
  deleteUser(id: string): Promise<void>;
} 