async uploadCoverImage(req, res) {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'Please upload a file' });
    }

    const novelId = req.params.id;
    const coverImagePath = `/uploads/covers/${req.file.filename}`;

    const novel = await this.novelUseCase.updateNovel(novelId, {
      coverImage: coverImagePath
    });

    res.status(200).json({
      success: true,
      data: novel
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
} 