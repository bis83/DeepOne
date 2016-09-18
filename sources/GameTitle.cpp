#include "GameTitle.h"
#include "DIManager.h"

GameTitle::GameTitle() {
	m_pSprTitleBack = new CSprite();
	m_pSprTitleBack->Init("Data/title_back.png");

	m_pSprTitleLogo = new CSprite();
	m_pSprTitleLogo->Init("Data/title.png");
	m_pSprTitleLogo->SetPos(0, 60);

	m_pSprGameStart = new CSprite();
	m_pSprGameStart->Init("Data/push_start.png");
	m_pSprGameStart->SetPos(160, 320);

	m_pSeStart = new CSound();
	m_pSeStart->Init("Data/gamestart.wav");

	Init();
}

GameTitle::~GameTitle() {
	delete m_pSprTitleBack;
	delete m_pSprTitleLogo;
	delete m_pSprGameStart;

	delete m_pSeStart;
}

void GameTitle::Init() {
	next_scene = -1;
}

void GameTitle::Update() {
	// 決定ボタンが押されたら
	if(g_pDIManager->IsKeyDownNow(0)) {
		m_pSeStart->Play(false, true);
		// ゲームを開始
		next_scene = 1;
	}
}

void GameTitle::Draw() {
	m_pSprTitleBack->Draw();
	m_pSprTitleLogo->Draw();
	m_pSprGameStart->Draw();
}

int GameTitle::IsNextScene() {
	return next_scene;
}