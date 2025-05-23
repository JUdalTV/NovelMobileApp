const ChapterController = require('../../../interfaces/controllers/ChapterController');
const { makeChapterUseCases } = require('../usecases/ChapterUseCasesFactory');

const makeChapterController = () => {
  const {
    getChapterByIdUseCase,
    getChaptersByNovelIdUseCase,
    getChapterByNovelAndNumberUseCase,
    createChapterUseCase,
    updateChapterUseCase,
    deleteChapterUseCase
  } = makeChapterUseCases();

  return new ChapterController(
    getChapterByIdUseCase,
    getChaptersByNovelIdUseCase,
    getChapterByNovelAndNumberUseCase,
    createChapterUseCase,
    updateChapterUseCase,
    deleteChapterUseCase
  );
};

module.exports = { makeChapterController };