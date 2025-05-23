const {
    GetChapterByIdUseCase,
    GetChaptersByNovelIdUseCase,
    GetChapterByNovelAndNumberUseCase,
    CreateChapterUseCase,
    UpdateChapterUseCase,
    DeleteChapterUseCase
  } = require('../../../usecases/chapter');
  const { makeChapterRepository } = require('../repositories/ChapterRepositoryFactory');
  const { makeNovelRepository } = require('../repositories/NovelRepositoryFactory');
  
  const makeChapterUseCases = () => {
    const chapterRepository = makeChapterRepository();
    const novelRepository = makeNovelRepository();
  
    return {
      getChapterByIdUseCase: new GetChapterByIdUseCase(chapterRepository),
      getChaptersByNovelIdUseCase: new GetChaptersByNovelIdUseCase(chapterRepository, novelRepository),
      getChapterByNovelAndNumberUseCase: new GetChapterByNovelAndNumberUseCase(chapterRepository, novelRepository),
      createChapterUseCase: new CreateChapterUseCase(chapterRepository, novelRepository),
      updateChapterUseCase: new UpdateChapterUseCase(chapterRepository),
      deleteChapterUseCase: new DeleteChapterUseCase(chapterRepository, novelRepository)
    };
  };
  
  module.exports = { makeChapterUseCases };