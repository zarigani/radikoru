radikoとradiruの録音スクリプト
===========================

インストール方法
-------------

ダウンロード後、解凍して、install.shを実行する。

  $ ~/Downloads/radikoru-master/install.sh

* インストール先は`/usr/local/bin/`

<br />

Homebrewをインストールして、必要なコマンドをインストールする。

	$ ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
	$ brew install wget
	$ brew install swftools
	$ brew install ffmpeg

<br />

rtmpdump2.4（バイナリ版）もダウンロードして、インストールする。

http://trick77.com/downloads/

* Homebrewのrtmpdumpはバージョンが古いため、ブラウザ経由でインストール

使い方
-----

`rec_radikoru.sh`は、`rec_radiko.sh`と`rec_radiru.sh`を統合するラッパースクリプト。

* ユーザーは`rec_radikoru.sh`を利用する。
* `rec_radikoru.sh`から、必要に応じて`rec_radiko.sh`と`rec_radiru.sh`が呼び出される。

<br />

`find_radiko.sh`は、radikoの番組表をキーワード検索するスクリプト。

* `find_radiru.sh`は、作ってない。
* 残念ながら、radiruでは検索するほど詳しい番組表が用意されていないので。

###マニュアル：rec_radikoru.sh

	Usage:  [-al] [-o output_path] [-t recording_seconds] station_ID
		     -a  Output area info(ex. JP13,東京都,tokyo Japan). No recording.
		     -l  Output station list. No recording.
		     -o  Default output_path = $HOME/Downloads/${station_name}_`date +%Y%m%d-%H%M`.flv
		             a/b/c/ = $HOME/Downloads/a/b/c/J-WAVE_20130123-1700.flv
		             a/b/c  = $HOME/Downloads/a/b/c.flv
		            /a/b/c/ = /a/b/c/J-WAVE_20130123-1700.flv
		            /a/b/c  = /a/b/c.flv
		           ./a/b/c/ = ./a/b/c/J-WAVE_20130123-1700.flv
		           ./a/b/c  = ./a/b/c.flv
		     -t  Default recording_seconds = 30
		           60 = 1 minute, 3600 = 1 hour, 0 = go on recording until stopped(control-C)

###実行例：radikoのエリア情報を出力

	$ rec_radikoru.sh -a
	==== authorize ====
	authtoken: U-FCNfMr7gCMUoQaiqPdvA
	 offset: 65547
	 length: 16
	 partialkey: oOM/h1/Wp95LIvIBzyDkEQ==
	authentication success
	areaid: JP13
	JP13,東京都,tokyo Japan

###実行例：ステーションIDのリストを出力

	$ rec_radikoru.sh -l
	---- ID ----    ---- NAME ----
	NHK-R1          NHK-R1
	NHK-R2          NHK-R2
	NHK-FM          NHK-FM
	TBS             TBSラジオ
	QRR             文化放送
	LFR             ニッポン放送
	RN1             ラジオNIKKEI第1 
	RN2             ラジオNIKKEI第2
	INT             InterFM
	FMT             TOKYO FM
	FMJ             J-WAVE
	JORF            ラジオ日本 
	BAYFM78         bayfm78
	NACK5           NACK5
	YFM             ＦＭヨコハマ 
	HOUSOU-DAIGAKU  放送大学

###実行例：J-WAVEを1時間、~/Downloads/radikoru/フォルダへ録音する
           
	$ rec_radikoru.sh -o radikoru/ -t 3600 FMJ

###マニュアル：find_radiko.sh

	$ find_radiko.sh 別所哲也
	AreaID=JP13
	
	-------------------- 20131014060000 10800 FMJ J-WAVE
	            <sub_title />  <pfm>別所哲也</pfm>
	====================
	timer -e 10/14 0600 /usr/local/bin/rec_radikoru.sh -o radikoru/ -t 10800 FMJ
	
	-------------------- 20131015060000 10800 FMJ J-WAVE
	            <sub_title />  <pfm>別所哲也</pfm>
	====================
	timer -e 10/15 0600 /usr/local/bin/rec_radikoru.sh -o radikoru/ -t 10800 FMJ
	
	-------------------- 20131016060000 10800 FMJ J-WAVE
	            <sub_title />  <pfm>別所哲也</pfm>
	            <desc>今朝も別所哲也が、あなたの“あさ時間”をナビゲート！今朝も、素敵な映画のをプレゼント☆メッセージと一緒にご応募ください！</desc>
	====================
	timer -e 10/16 0600 /usr/local/bin/rec_radikoru.sh -o radikoru/ -t 10800 FMJ
	
	-------------------- 20131017060000 10800 FMJ J-WAVE
	            <sub_title />  <pfm>別所哲也</pfm>
	====================
	timer -e 10/17 0600 /usr/local/bin/rec_radikoru.sh -o radikoru/ -t 10800 FMJ

* 今週のradikoの番組表の中から、「別所哲也」を含む番組を出力する。
* 上記の出力結果には、4つの番組がヒットしている。
* ----と====の行間が、番組の内容。
* ====の下には、timerコマンドと連携してタイマー予約するコマンドが出力される。
* タイマー予約するコマンドをコピー＆ペーストして実行することで、録音予約できる。
