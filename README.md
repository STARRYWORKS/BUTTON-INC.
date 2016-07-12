# BUTTON INC.
## サイト
[http://btn-inc.jp](http://btn-inc.jp)

### 環境設定
・gulp-audiospriteを使用するのにffmpegが必要です。
brewでffmpegをインストール

```
brew install ffmpeg --with-theora --with-libogg --with-libvorbis
```

※El Capitanでbrewした際にエラーが出たら
```
sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local
```