#include "GameMain.h"
#include "DIManager.h"

GameMain::GameMain() {
	pPlayer = new Player();
	pPhoton = new Photon();
	pGate = new Gate();
	pGate->SetPhoton(pPhoton);

	m_pSprBack = new CSprite();
	m_pSprBack->Init("Data/field01.png");

	m_pSprFrame = new CSprite();
	m_pSprFrame->Init("Data/frame.png");

	m_pSprTime = new CSprite();
	m_pSprTime->Init("Data/time.png");

	m_pSprNumber = new CSprite();
	m_pSprNumber->Init("Data/number.png");

	m_pSprLevel = new CSprite();
	m_pSprLevel->Init("Data/level.png");

	m_pSprScore = new CSprite();
	m_pSprScore->Init("Data/score.png");

	m_pSprTimeF = new CSprite();
	m_pSprTimeF->Init("Data/time_f.png");

	m_pSprGameOver = new CSprite();
	m_pSprGameOver->Init("Data/gameover.png");

	m_pSprClear = new CSprite();
	m_pSprClear->Init("Data/clear.png");

	m_pSeLevelupOne = new CSound();
	m_pSeLevelupOne->Init("Data/levelup_one.wav");

	m_pSeLevelupTen = new CSound();
	m_pSeLevelupTen->Init("Data/levelup_ten.wav");

	m_pSeGameOver = new CSound();
	m_pSeGameOver->Init("Data/gameover.wav");

	m_pSeClear = new CSound();
	m_pSeClear->Init("Data/clear.wav");

	m_pBgmMain = new CMusic();
	m_pBgmMain->Init("Data/ThePolarStar.ogg");

	Init();
}

void GameMain::Init() {
	time = 60 * 20;
	level = 1;
	score = 0;
	level_time = 0;
	pPlayer->Init();
	pPhoton->Init();
	pGate->Init();
	next_scene = -1;
	srand(timeGetTime());
	wait = 0;
	gameover = false;
	complete = false;
}

GameMain::~GameMain() {
	delete pPlayer;
	delete pPhoton;
	delete pGate;

	delete m_pSprBack;
	delete m_pSprFrame;
	delete m_pSprTime;
	delete m_pSprNumber;
	delete m_pSprLevel;
	delete m_pSprScore;
	delete m_pSprTimeF;
	delete m_pSprGameOver;
	delete m_pSprClear;

	delete m_pSeLevelupOne;
	delete m_pSeLevelupTen;
	delete m_pSeGameOver;
	delete m_pSeClear;

	delete m_pBgmMain;
}

void GameMain::Update() {

	if(wait) {
		wait--;
		return;
	}

	if(gameover) {
		if(g_pDIManager->IsKeyDownNow(0))
			next_scene = 0;
		return;
	}

	if(complete) {
		if(g_pDIManager->IsKeyDownNow(0))
			next_scene = 0;
		return;
	}

	if(!m_pBgmMain->IsPlaying())
		m_pBgmMain->Play(true, true, 0);
	if(time < 60) {
		m_pBgmMain->SetFrequency(200);
	} else if(time < 60*3) {
		m_pBgmMain->SetFrequency(150);
	} else if(time < 60*5) {
		m_pBgmMain->SetFrequency(125);
	} else {
		m_pBgmMain->SetFrequency(100);
	}
	m_pBgmMain->Update();

	// プレイヤーの移動、反転
	pPlayer->Move();

	// 光子の移動
	pPhoton->Move();

	// ゲートの移動
	pGate->Move();

	// ゲートの発生
	if(time % 60 == 0) {
		pGate->CreateNewGate(rand()%8, rand()%300+160, rand()%300+80, level);
	}

	// 光子とプレイヤーの当たり判定
	int i = pPhoton->HitPlayerAndCristal(pPlayer);
	score += i * 10;

	// ゲートとプレイヤーの当たり判定
	i = pGate->HitPlayerAndCristal(pPlayer);
	score += i * 200;
	time += i * (5-level/20) * 60;
	if(pGate->GateZero()) {
		time += (level / 20) * 60;
		score += (level / 20) * 1000;
	}
	if(time > 30 * 60) {
		time = 30 * 60;
	}

	// スコアのカンスト
	if(score >= 99999999) {
		score = 99999999;
	}

	// タイムの処理
	if(time > 0) time -= 1;
	if(time <= 0) {
		// ゲームオ－バー
		m_pBgmMain->Stop();
		m_pSeGameOver->Play(false, true);
		wait = 180;
		gameover = true;
		return;
	}

	level_time++;
	if(level_time >= 10*60) {
		level_time = 0;
		level++;
		if(level % 10 == 0) {
			m_pSeLevelupTen->Play(false, true);
		} else {
			m_pSeLevelupOne->Play(false, true);
		}

		if(level >= 100) {
			level = 99;
			// ゲームクリア
			m_pBgmMain->Stop();
			m_pSeClear->Play(false, true);
			wait = 180;
			complete = true;
			return;
		}
	}
}

void GameMain::Draw() {
	// 背景の描画
	m_pSprBack->SetPos(120, 40);
	m_pSprBack->Draw();

	// ゲートの描画
	pGate->Draw();

	// プレイヤーの描画
	pPlayer->Draw();

	// 光子の描画
	pPhoton->Draw();

	// 枠の描画
	m_pSprFrame->SetPos(0, 0);
	m_pSprFrame->Draw();

	// スコアやレベル、タイムの描画
	m_pSprTime->SetPos(120, 450);
	m_pSprTime->SetColor(196, 36, 36, 36);
	m_pSprTime->SetUV(0, 0, 400, 20);
	m_pSprTime->Draw();

	m_pSprTime->SetColor(196, 255, 255, 255);
	m_pSprTime->SetUV(0, 0, 400 * time / (60.0f * 30), 20.0f);
	m_pSprTime->Draw();

	// スコア
	m_pSprScore->SetPos(130, 0);
	m_pSprScore->Draw();
	int keta = 10000000;
	int j = score;
	m_pSprNumber->SetScale(1.0f, 1.0f);
	for(int i=0; i<8; ++i) {
		int k = j / keta;
		m_pSprNumber->SetPos(260+24*i, 8);
		m_pSprNumber->SetUV(k*24, 0, k*24+24, 24);
		m_pSprNumber->Draw();
		j %= keta;
		keta /= 10;
	}

	m_pSprLevel->SetPos(0, 40);
	m_pSprLevel->Draw();
	keta = 10;
	j = level;
	m_pSprNumber->SetScale(1.5f, 1.5f);
	for(int i=0; i<2; ++i) {
		int k = j / keta;
		m_pSprNumber->SetPos(20+36*i, 120);
		m_pSprNumber->SetUV(k*24, 0, k*24+24, 24);
		m_pSprNumber->Draw();
		j %= keta;
		keta /= 10;
	}

	m_pSprTimeF->SetPos(0, 400);
	m_pSprTimeF->Draw();
	keta =  100;
	j = time / 60;
	m_pSprNumber->SetScale(1.0f, 1.0f);
	for(int i=0; i<3; ++i) {
		int k = j / keta;
		m_pSprNumber->SetPos(80+24*i, 440);
		m_pSprNumber->SetUV(k*24, 0, k*24+24, 24);
		m_pSprNumber->Draw();
		j %= keta;
		keta /= 10;
	}

	// ゲームオーバーやクリア画面の描画
	if(gameover) {
		m_pSprGameOver->SetColor(255-wait, 255, 255, 255);
		m_pSprGameOver->Draw();

		keta = 10000000;
		j = score;
		m_pSprNumber->SetScale(2.0f, 2.0f);
		for(int i=0; i<8; ++i) {
			int k = j / keta;
			m_pSprNumber->SetPos(120+48*i, 360);
			m_pSprNumber->SetUV(k*24, 0, k*24+24, 24);
			m_pSprNumber->Draw();
			j %= keta;
			keta /= 10;
		}
	}
	if(complete) {
		m_pSprClear->SetColor(255-wait, 255, 255, 255);
		m_pSprClear->Draw();

		keta = 10000000;
		j = score;
		m_pSprNumber->SetScale(2.0f, 2.0f);
		for(int i=0; i<8; ++i) {
			int k = j / keta;
			m_pSprNumber->SetPos(120+48*i, 360);
			m_pSprNumber->SetUV(k*24, 0, k*24+24, 24);
			m_pSprNumber->Draw();
			j %= keta;
			keta /= 10;
		}
	}
}

int GameMain::IsNextScene() {
	return next_scene;
}