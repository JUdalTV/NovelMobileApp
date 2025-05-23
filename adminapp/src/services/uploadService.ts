import axios from 'axios';
import { API_URL } from '../config';

interface UploadResponse {
  success: boolean;
  message: string;
  data: {
    coverImage: string;
  };
}

export const uploadCoverImage = async (novelId: string, file: File): Promise<string> => {
  const formData = new FormData();
  formData.append('coverImage', file);

  const response = await axios.post<UploadResponse>(`${API_URL}/novels/${novelId}/cover`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });

  return response.data.data.coverImage;
}; 