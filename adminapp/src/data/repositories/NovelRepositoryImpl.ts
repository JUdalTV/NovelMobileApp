import axiosInstance from '../../utils/axios';
import { Novel } from '../../domain/entities/Novel';
import { NovelRepository } from '../../domain/repositories/NovelRepository';

export class NovelRepositoryImpl implements NovelRepository {
  async getNovels(): Promise<Novel[]> {
    const response = await axiosInstance.get<Novel[]>('/novels');
    return response.data;
  }

  async getNovelById(id: string): Promise<Novel> {
    const response = await axiosInstance.get<Novel>(`/novels/${id}`);
    return response.data;
  }

  async createNovel(novel: Omit<Novel, 'id' | 'createdAt' | 'updatedAt'>): Promise<Novel> {
    const response = await axiosInstance.post<Novel>('/novels', novel);
    return response.data;
  }

  async updateNovel(id: string, novel: Partial<Novel>): Promise<Novel> {
    const response = await axiosInstance.put<Novel>(`/novels/${id}`, novel);
    return response.data;
  }

  async deleteNovel(id: string): Promise<void> {
    await axiosInstance.delete(`/novels/${id}`);
  }

  async getNovelStats(): Promise<{
    totalNovels: number;
    totalViews: number;
    averageRating: number;
  }> {
    const response = await axiosInstance.get<{
      totalNovels: number;
      totalViews: number;
      averageRating: number;
    }>('/novels/stats');
    return response.data;
  }
} 