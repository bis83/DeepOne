#include "GameMain.h"

#include "DIManager.h"

Player::Player() {
	m_pSprPlayer = new CSprite();
	m_pSprPlayer->Init("Data/player_cristal.png");
	Init();

	m_pSeReflect = new CSound();
	m_pSeReflect->Init("Data/reflect.wav");
}

void Player::Init() {
	player_pos_x = 320 - 32;
	player_pos_y = 360 - 32;
	player_color = 0;
	cristal_pos_x = 320 - 32;
	cristal_pos_y = 360 - 96;
	cristal_v_x = 0.0f;
	cristal_v_y = 0.0f;
	cristal_color = 1;
}

Player::~Player() {
	delete m_pSprPlayer;

	delete m_pSeReflect;
}

void Player::Move() {
	// 反転
	if(g_pDIManager->IsKeyDownNow(0)) {
		if(player_color == 0) {
			player_color = 1;
			cristal_color = 0;
		} else {
			player_color = 0;
			cristal_color = 1;
		}
	}

	// プレイヤーの移動
	if(abs(g_pDIManager->GetAnalog(0)) > 500) {
		player_pos_x += 5.0f * (g_pDIManager->GetAnalog(0) > 0 ? 1 : -1) / (abs(g_pDIManager->GetAnalog(1)) > 500 ?  sqrt(2.0f) : 1.0f);
	}
	if(abs(g_pDIManager->GetAnalog(1)) > 500) {
		player_pos_y += 5.0f * (g_pDIManager->GetAnalog(1) > 0 ? 1 : -1) / (abs(g_pDIManager->GetAnalog(0)) > 500 ?  sqrt(2.0f) : 1.0f);
	}

	// 壁の制限
	if(player_pos_x < 110) {
		player_pos_x = 110.0f;
	}
	if(player_pos_x > 530 - 64) {
		player_pos_x = 530.0f - 64.0f;
	}
	if(player_pos_y < 30) {
		player_pos_y = 30.0f;
	}
	if(player_pos_y > 450 - 64) {
		player_pos_y = 450.0f - 64.0f;
	}

	// クリスタルの移動
	cristal_pos_x += cristal_v_x;
	cristal_pos_y += cristal_v_y;

	// プレイヤーとの反射
	if( pow( player_pos_x - cristal_pos_x, 2 ) + pow( player_pos_y - cristal_pos_y, 2 ) < pow( 64.0f, 2)) {
		// クリスタルに速度を与える
		cristal_v_x = cristal_pos_x - player_pos_x;
		cristal_v_y = cristal_pos_y - player_pos_y;
		float nom = sqrt(cristal_v_x*cristal_v_x + cristal_v_y*cristal_v_y);
		cristal_v_x /= nom;
		cristal_v_y /= nom;
		cristal_v_x *= 6.0f;
		cristal_v_y *= 6.0f;
		m_pSeReflect->Play(false, true);
	}

	// 壁との反射
	if(cristal_pos_x < 110 || cristal_pos_x > 520 - 64) {
		cristal_v_x = -cristal_v_x;
		m_pSeReflect->Play(false, true);
	}
	if(cristal_pos_y < 30 || cristal_pos_y > 440 - 64) {
		cristal_v_y = -cristal_v_y;
		m_pSeReflect->Play(false, true);
	}

	// 壁の制限
	if(cristal_pos_x < 110) {
		cristal_pos_x = 110.0f;
	}
	if(cristal_pos_x > 520 - 64) {
		cristal_pos_x = 520.0f - 64.0f;
	}
	if(cristal_pos_y < 30) {
		cristal_pos_y = 30.0f;
	}
	if(cristal_pos_y > 440 - 64) {
		cristal_pos_y = 440.0f - 64.0f;
	}
}

void Player::Draw() {
	// プレイヤーの描画
	if(player_color == 0) {
		m_pSprPlayer->SetUV(0, 0, 64, 64);
	} else {
		m_pSprPlayer->SetUV(64, 0, 128, 64);
	}
	m_pSprPlayer->SetPos(player_pos_x, player_pos_y);
	m_pSprPlayer->Draw();

	// クリスタルの描画
	if(cristal_color == 0) {
		m_pSprPlayer->SetUV(0, 64, 64, 128);
	} else {
		m_pSprPlayer->SetUV(64, 64, 128, 128);
	}
	m_pSprPlayer->SetPos(cristal_pos_x, cristal_pos_y);
	m_pSprPlayer->Draw();
}

bool Player::HitPlayer(float pos_x, float pos_y, float r, int color) {
	return ( (player_color == color) &&
		pow( player_pos_x + 32.0f - pos_x, 2 ) + pow( player_pos_y + 32.0f - pos_y, 2 ) < pow( r + 24.0f , 2 ) );
}

bool Player::HitCristal(float pos_x, float pos_y, float r, int color) {
	if( (cristal_color == color) &&
		( pow( cristal_pos_x + 32.0f - pos_x, 2 ) + pow( cristal_pos_y + 32.0f - pos_y, 2 ) < pow( r + 24.0f , 2 ) ) ) {
			cristal_v_x = cristal_pos_x - pos_x;
			cristal_v_y = cristal_pos_y - pos_y;
			float nom = sqrt(cristal_v_x*cristal_v_x + cristal_v_y*cristal_v_y);
			cristal_v_x /= nom;
			cristal_v_y /= nom;
			cristal_v_x *= 6.0f;
			cristal_v_y *= 6.0f;
			m_pSeReflect->Play(false, true);
			return true;
	}
	return false;
}
