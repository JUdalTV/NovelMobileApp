import axios from 'axios';
import { Novel, NovelFormData } from '../../domain/entities/Novel';
import { API_URL } from '../../config';

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

interface PaginatedResponse<T> {
  success: boolean;
  count: number;
  pagination: {
    page: number;
    limit: number;
    totalPages: number;
  };
  data: T[];
}

class NovelRepository {
  private readonly baseUrl = `${API_URL}/novels`;

  async getAllNovels(page = 1, limit = 10): Promise<Novel[]> {
    const response = await axios.get<PaginatedResponse<Novel>>(this.baseUrl, {
      params: { page, limit },
    });
    return response.data.data;
  }

  async getNovelById(id: string): Promise<Novel> {
    const response = await axios.get<ApiResponse<Novel>>(`${this.baseUrl}/${id}`);
    return response.data.data;
  }

  async getNovelBySlug(slug: string): Promise<Novel> {
    const response = await axios.get<ApiResponse<Novel>>(`${this.baseUrl}/slug/${slug}`);
    return response.data.data;
  }

  async createNovel(novel: NovelFormData): Promise<Novel> {
    const response = await axios.post<ApiResponse<Novel>>(this.baseUrl, novel);
    return response.data.data;
  }

  async updateNovel(id: string, novel: Partial<NovelFormData>): Promise<Novel> {
    const response = await axios.put<ApiResponse<Novel>>(`${this.baseUrl}/${id}`, novel);
    return response.data.data;
  }

  async deleteNovel(id: string): Promise<void> {
    await axios.delete(`${this.baseUrl}/${id}`);
  }

  async searchNovels(query: string, page = 1, limit = 10): Promise<Novel[]> {
    const response = await axios.get<PaginatedResponse<Novel>>(`${this.baseUrl}/search`, {
      params: { q: query, page, limit },
    });
    return response.data.data;
  }
}

export const novelRepository = new NovelRepository(); 