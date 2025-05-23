import axios from 'axios';
import { Chapter } from '../../domain/entities/Chapter';
import { API_URL } from '../../config';

interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
}

interface PaginatedResponse<T> {
  success: boolean;
  data: T[];
  total: number;
  page: number;
  limit: number;
}

class ChapterRepository {
  private readonly baseUrl = `${API_URL}/chapters`;

  async getChaptersByNovelId(novelId: string, page = 1, limit = 50): Promise<Chapter[]> {
    const response = await axios.get<PaginatedResponse<Chapter>>(`${this.baseUrl}/novel/${novelId}`, {
      params: { page, limit },
    });
    return response.data.data;
  }

  async getChapterById(id: string): Promise<Chapter> {
    const response = await axios.get<ApiResponse<Chapter>>(`${this.baseUrl}/${id}`);
    return response.data.data;
  }

  async createChapter(chapterData: Partial<Chapter>): Promise<Chapter> {
    const response = await axios.post<ApiResponse<Chapter>>(this.baseUrl, chapterData);
    return response.data.data;
  }

  async updateChapter(id: string, chapterData: Partial<Chapter>): Promise<Chapter> {
    const response = await axios.put<ApiResponse<Chapter>>(`${this.baseUrl}/${id}`, chapterData);
    return response.data.data;
  }

  async deleteChapter(id: string): Promise<void> {
    await axios.delete(`${this.baseUrl}/${id}`);
  }
}

export const chapterRepository = new ChapterRepository(); 