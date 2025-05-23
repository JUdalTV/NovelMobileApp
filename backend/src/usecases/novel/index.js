const GetAllNovelsUseCase = require('./GetAllNovelsUseCase');
const GetNovelByIdUseCase = require('./GetNovelByIdUseCase');
const GetNovelBySlugUseCase = require('./GetNovelBySlugUseCase');
const CreateNovelUseCase = require('./CreateNovelUseCase');
const UpdateNovelUseCase = require('./UpdateNovelUseCase');
const DeleteNovelUseCase = require('./DeleteNovelUseCase');
const SearchNovelsUseCase = require('./SearchNovelsUseCase');
const UploadCoverImageUseCase = require('./UploadCoverImageUseCase');

module.exports = {
  GetAllNovelsUseCase,
  GetNovelByIdUseCase,
  GetNovelBySlugUseCase,
  CreateNovelUseCase,
  UpdateNovelUseCase,
  DeleteNovelUseCase,
  SearchNovelsUseCase,
  UploadCoverImageUseCase
};