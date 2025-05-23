const { NotFoundError } = require('../../domain/errors');
const fs = require('fs');
const path = require('path');
const mammoth = require('mammoth');

class ChapterController {
  constructor(
    getChapterByIdUseCase,
    getChaptersByNovelIdUseCase,
    getChapterByNovelAndNumberUseCase,
    createChapterUseCase,
    updateChapterUseCase,
    deleteChapterUseCase
  ) {
    this.getChapterByIdUseCase = getChapterByIdUseCase;
    this.getChaptersByNovelIdUseCase = getChaptersByNovelIdUseCase;
    this.getChapterByNovelAndNumberUseCase = getChapterByNovelAndNumberUseCase;
    this.createChapterUseCase = createChapterUseCase;
    this.updateChapterUseCase = updateChapterUseCase;
    this.deleteChapterUseCase = deleteChapterUseCase;
  }

  async getChapterById(req, res, next) {
    try {
      const { id } = req.params;
      const chapter = await this.getChapterByIdUseCase.execute(id);
      
      res.status(200).json({
        success: true,
        data: chapter
      });
    } catch (error) {
      if (error.message === 'Chapter not found') {
        return next(new NotFoundError('Không tìm thấy chương'));
      }
      next(error);
    }
  }

  async getChaptersByNovelId(req, res, next) {
    try {
      const novelId = req.params.id || req.params.novelId;
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 50;
      
      const chapters = await this.getChaptersByNovelIdUseCase.execute(novelId, page, limit);
      
      res.status(200).json({
        success: true,
        count: chapters.total,
        pagination: {
          page,
          limit,
          totalPages: Math.ceil(chapters.total / limit)
        },
        data: chapters.items
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }

  async getChapterByNovelAndNumber(req, res, next) {
    try {
      const novelId = req.params.id || req.params.novelId;
      const chapterNumber = parseInt(req.params.chapterNumber, 10);
      
      const chapter = await this.getChapterByNovelAndNumberUseCase.execute(
        novelId,
        chapterNumber
      );
      
      res.status(200).json({
        success: true,
        data: chapter
      });
    } catch (error) {
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      if (error.message === 'Chapter not found') {
        return next(new NotFoundError('Không tìm thấy chương'));
      }
      next(error);
    }
  }

  async _extractContentFromDocx(buffer) {
    try {
      console.log('Extracting content from docx file, buffer size:', buffer.length);
      const result = await mammoth.extractRawText({ buffer });
      console.log('Extracted content length:', result.value.length, 'characters');
      return result.value;
    } catch (error) {
      console.error('Error extracting content from docx:', error);
      throw new Error('Không thể đọc nội dung từ file .docx');
    }
  }

  async createChapter(req, res, next) {
    try {
      console.log('Creating chapter with data:', {
        title: req.body.title,
        chapterNumber: req.body.chapterNumber,
        novelId: req.body.novelId,
        hasContent: !!req.body.content,
        hasDocumentFile: !!req.body.documentFile
      });
      
      const chapterData = {
        title: req.body.title,
        chapterNumber: parseInt(req.body.chapterNumber, 10),
        novelId: req.body.novelId,
        content: req.body.content || ''
      };
      
      console.log('ChapterController - Dữ liệu chapter được gửi tới use case:', chapterData);
      
      // Kiểm tra lại lần cuối các trường cần thiết
      if (!chapterData.title) {
        return next(new Error('Tiêu đề chương là bắt buộc'));
      }
      
      if (typeof chapterData.chapterNumber !== 'number' || isNaN(chapterData.chapterNumber)) {
        return next(new Error('Số chương không hợp lệ'));
      }
      
      if (!chapterData.novelId) {
        return next(new Error('ID tiểu thuyết là bắt buộc'));
      }
      
      // Nếu không có nội dung nhưng có file document, đọc nội dung từ file
      if (!chapterData.content && req.body.documentFile) {
        try {
          console.log('Processing uploaded document file:', {
            originalname: req.body.documentFile.originalname,
            mimetype: req.body.documentFile.mimetype,
            size: req.body.documentFile.size
          });
          
          const content = await this._extractContentFromDocx(req.body.documentFile.buffer);
          chapterData.content = content;
          
          console.log('Document content extracted successfully, length:', content.length);
        } catch (error) {
          console.error('Error processing document file:', error);
          return next(error);
        }
      }
      
      // Kiểm tra xem có nội dung chưa
      if (!chapterData.content || chapterData.content.trim() === '') {
        console.error('Missing chapter content');
        return next(new Error('Thiếu nội dung chương. Vui lòng cung cấp nội dung trực tiếp hoặc qua file.'));
      }
      
      const chapter = await this.createChapterUseCase.execute(chapterData);
      
      console.log('Chapter created successfully:', chapter);
      
      res.status(201).json({
        success: true,
        message: 'Thêm chương mới thành công',
        data: chapter
      });
    } catch (error) {
      console.error('Error creating chapter:', error);
      if (error.message === 'Novel not found') {
        return next(new NotFoundError('Không tìm thấy truyện'));
      }
      next(error);
    }
  }

  async updateChapter(req, res, next) {
    try {
      const { id } = req.params;
      const chapterData = req.body;
      
      if (req.body.documentFile) {
        try {
          console.log('Processing uploaded document file for update:', {
            originalname: req.body.documentFile.originalname,
            mimetype: req.body.documentFile.mimetype,
            size: req.body.documentFile.size
          });
          
          const content = await this._extractContentFromDocx(req.body.documentFile.buffer);
          chapterData.content = content;
          
          // Xóa thông tin file khỏi dữ liệu
          delete chapterData.documentFile;
          console.log('Document content extracted successfully for update, length:', content.length);
        } catch (error) {
          console.error('Error processing document file for update:', error);
          return next(error);
        }
      }
      
      const chapter = await this.updateChapterUseCase.execute(id, chapterData);
      
      res.status(200).json({
        success: true,
        message: 'Cập nhật chương thành công',
        data: chapter
      });
    } catch (error) {
      console.error('Error updating chapter:', error);
      if (error.message === 'Chapter not found') {
        return next(new NotFoundError('Không tìm thấy chương'));
      }
      next(error);
    }
  }

  async deleteChapter(req, res, next) {
    try {
      const { id } = req.params;
      await this.deleteChapterUseCase.execute(id);
      
      res.status(200).json({
        success: true,
        message: 'Xóa chương thành công'
      });
    } catch (error) {
      if (error.message === 'Chapter not found') {
        return next(new NotFoundError('Không tìm thấy chương'));
      }
      next(error);
    }
  }
}

module.exports = ChapterController;