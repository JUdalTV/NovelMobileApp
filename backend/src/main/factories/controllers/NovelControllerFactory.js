const NovelController = require('../../../interfaces/controllers/NovelController');
const { makeNovelUseCases } = require('../usecases/NovelUseCasesFactory');

const makeNovelController = () => {
  const {
    getAllNovelsUseCase,
    getNovelByIdUseCase,
    getNovelBySlugUseCase,
    createNovelUseCase,
    updateNovelUseCase,
    deleteNovelUseCase,
    searchNovelsUseCase,
    uploadCoverImageUseCase
  } = makeNovelUseCases();

  return new NovelController(
    getAllNovelsUseCase,
    getNovelByIdUseCase,
    getNovelBySlugUseCase,
    createNovelUseCase,
    updateNovelUseCase,
    deleteNovelUseCase,
    searchNovelsUseCase,
    uploadCoverImageUseCase
  );
};

module.exports = { makeNovelController };