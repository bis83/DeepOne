#pragma once

#include "Sprite.h"
#include "DSManager.h"

// ゲームタイトル
class GameTitle {
	ISprite *m_pSprTitleBack;
	ISprite *m_pSprTitleLogo;
	ISprite *m_pSprGameStart;

	CSound *m_pSeStart;

	int next_scene;
public:
	GameTitle();
	~GameTitle();

	void Init();

	void Update();

	void Draw();

	int IsNextScene();
};
