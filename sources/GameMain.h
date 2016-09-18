#pragma once

#include "Sprite.h"
#include "DSManager.h"

// �v���C���[�ƃN���X�^��
class Player {
	ISprite *m_pSprPlayer;

	CSound *m_pSeReflect;

	float player_pos_x, player_pos_y;
	int player_color;		// �J���[(0:��, 1:���F)

	float cristal_pos_x, cristal_pos_y;
	float cristal_v_x, cristal_v_y;
	int cristal_color;
public:
	Player();
	~Player();

	void Init();

	void Move();
	void Draw();
	bool HitPlayer(float pos_x, float pos_y, float r, int color);
	bool HitCristal(float pos_x, float pos_y, float r, int color);

};

// �t�H�g��(���q)
#define MAX_PHOTON 512

class Photon {
	ISprite *m_pSprTama;

	CSound *m_pSeTamakie;	// �e�̏����鉹

	struct photon {
		float pos_x, pos_y;
		float v_x, v_y;
		int type;
		bool active;
	};

	photon m_photonlist[MAX_PHOTON];
public:
	Photon();
	~Photon();

	void Init();

	void Move();
	void Draw();
	int HitPlayerAndCristal(Player *pPlayer);	// �Ԃ�l�̓N���X�^�������������q�̐�
	void CreateNewPhoton(int type, float pos_x, float pos_y, float v_x, float v_y);
};

// �Q�[�g
// 0 : �~�e
// 1 : ��e
// 2 : �Q�����e
// 3 : �΂�܂��e
// 4 : ���d�~�e
// 5 : ��way��e
// 6 : ��d�����܂��e
// 7 : �����܂��΂�܂��e

#define MAX_GATE 10

class Gate {
	ISprite *m_pSprGate;

	CSound *m_pSeGateAppear;	// �Q�[�g�̏o��
	CSound *m_pSeGatekie;	// �Q�[�g�̏����鉹
	CSound *m_pSeTamahassya;	// �e�̔��ˉ�

	struct gate {
		float v_x, v_y;
		float pos_x, pos_y;
		int type;
		int level;
		int time;
		bool active;
	};

	gate m_gatelist[MAX_GATE];
	int nActiveGate;
	bool zero_flag;

	Photon *m_pPhoton;
public:
	Gate();
	~Gate();
	void SetPhoton(Photon *pPhoton);
	
	void Init();

	void Move();
	void Draw();
	// �Ԃ�l�͏������Q�[�g�̐�
	int HitPlayerAndCristal(Player *pPlayer);
	void CreateNewGate(int type, float pos_x, float pos_y, int level);
	bool GateZero();
};

// �Q�[�����C��
class GameMain {
	ISprite *m_pSprBack;
	ISprite *m_pSprFrame;
	ISprite *m_pSprNumber;
	ISprite *m_pSprTime;

	ISprite *m_pSprLevel;
	ISprite *m_pSprScore;
	ISprite *m_pSprTimeF;

	ISprite *m_pSprGameOver;
	ISprite *m_pSprClear;

	CSound *m_pSeLevelupOne;
	CSound *m_pSeLevelupTen;
	CSound *m_pSeGameOver;
	CSound *m_pSeClear;

	CMusic *m_pBgmMain;

	int score, level, time;
	int level_time;

	Player *pPlayer;
	Photon *pPhoton;
	Gate *pGate;

	bool gameover;
	bool complete;
	int wait;
	int next_scene;
public:
	GameMain();
	~GameMain();

	void Init();

	void Update();
	void Draw();

	int IsNextScene();
};
