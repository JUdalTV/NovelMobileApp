const {
    GetAllNovelsUseCase,
    GetNovelByIdUseCase,
    GetNovelBySlugUseCase,
    CreateNovelUseCase,
    UpdateNovelUseCase,
    DeleteNovelUseCase,
    SearchNovelsUseCase,
    UploadCoverImageUseCase
  } = require('../../../usecases/novel');
  const { makeNovelRepository } = require('../repositories/NovelRepositoryFactory');
  const { makeChapterRepository } = require('../repositories/ChapterRepositoryFactory');
  const { makeFileStorage } = require('../storage/FileStorageFactory');
  
  const makeNovelUseCases = () => {
    const novelRepository = makeNovelRepository();
    const chapterRepository = makeChapterRepository();
    const fileStorage = makeFileStorage();
  
    return {
      getAllNovelsUseCase: new GetAllNovelsUseCase(novelRepository),
      getNovelByIdUseCase: new GetNovelByIdUseCase(novelRepository),
      getNovelBySlugUseCase: new GetNovelBySlugUseCase(novelRepository),
      createNovelUseCase: new CreateNovelUseCase(novelRepository, fileStorage),
      updateNovelUseCase: new UpdateNovelUseCase(novelRepository, fileStorage),
      deleteNovelUseCase: new DeleteNovelUseCase(novelRepository, chapterRepository, fileStorage),
      searchNovelsUseCase: new SearchNovelsUseCase(novelRepository),
      uploadCoverImageUseCase: new UploadCoverImageUseCase(novelRepository, fileStorage)
    };
  };
  
  module.exports = { makeNovelUseCases };