import axiosInstance from '../../utils/axios';
import { Comment } from '../../domain/entities/Comment';
import { CommentRepository } from '../../domain/repositories/CommentRepository';

export class CommentRepositoryImpl implements CommentRepository {
  async getComments(): Promise<Comment[]> {
    const response = await axiosInstance.get<Comment[]>('/comments');
    return response.data;
  }

  async getCommentById(id: string): Promise<Comment> {
    const response = await axiosInstance.get<Comment>(`/comments/${id}`);
    return response.data;
  }

  async getCommentsByNovelId(novelId: string): Promise<Comment[]> {
    const response = await axiosInstance.get<Comment[]>(`/comments/novel/${novelId}`);
    return response.data;
  }

  async createComment(comment: Omit<Comment, 'id' | 'createdAt' | 'updatedAt'>): Promise<Comment> {
    const response = await axiosInstance.post<Comment>('/comments', comment);
    return response.data;
  }

  async updateComment(id: string, comment: Partial<Comment>): Promise<Comment> {
    const response = await axiosInstance.put<Comment>(`/comments/${id}`, comment);
    return response.data;
  }

  async deleteComment(id: string): Promise<void> {
    await axiosInstance.delete(`/comments/${id}`);
  }

  async getReportedComments(): Promise<Comment[]> {
    const response = await axiosInstance.get<Comment[]>('/comments/reported');
    return response.data;
  }

  async getCommentStats(): Promise<{
    totalComments: number;
    reportedComments: number;
    totalLikes: number;
  }> {
    const response = await axiosInstance.get<{
      totalComments: number;
      reportedComments: number;
      totalLikes: number;
    }>('/comments/stats');
    return response.data;
  }
} 