//
//  Bank.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import Foundation

enum Bank: String, CaseIterable {
    case kakao = "카카오뱅크"
    case kb = "국민은행"
    case ibk = "기업은행"
    case nh = "농협"
    case shinhan = "신한은행"
    case kdb = "산업은행"
    case woori = "우리은행"
    case citi = "한국시티은행"
    case hana = "하나은행"
    case exchange = "외환은행"
    case sc = "SC제일은행"
    case kyongnam = "경남은행"
    case gwangju = "광주은행"
    case daegu = "대구은행"
    case busan = "부산은행"
    case saemaeul = "새마을금고"
    case sh = "수협은행"
    case postoffice = "우체국"
    case jeonbuk = "전북은행"
    case jeju = "제주은행"
    case kbank = "케이뱅크"
}


enum BankApp: String, CaseIterable {
    case kakaopay = "카카오페이"
    case kakaobank = "카카오뱅크"
    case supertoss = "토스"
    case kbBank = "KB스타뱅킹"
    case liivbank = "리브"
    case liivtalk = "리브똑똑"
    case newnhsmartbanking = "NH스마트뱅킹"
    case NHCOK = "NH콕뱅크"
    case NHAllOneBank = "NH올원뱅크"
    case ionebank = "IBK기업은행"
    case sbankmoasign = "신한 쏠(SOL)"
    case smartkdb = "스마트KDB"
    case NewSmartPib = "우리 WON 뱅킹"
    case SmartBank2WIB = "위비뱅크"
    case KTollehCitiMobile = "시티모바일"
    case hanapush = "하나원큐"
    case hanawalletmembers = "하나멤버스"
    case VeraPortCG = "SC제일은행"
    case nfs = "BNK경남은행"
    case kjbankpb = "광주은행"
    case dgbmbanking = "IM뱅크"
    case bslink = "BNK부산은행"
    case sumbank = "썸뱅크"
    case kfccSB = "MG더뱅킹"
    case mgsangsangbank = "MG상상뱅크"
    case suhyuppesmb = "헤이뱅크"
    case suhyuppsmb = "파트너뱅크"
    case postpay = "우체국"
    case jbsmartbank = "전북은행"
    case jbanksmartBankSign = "제주모바일뱅킹"
    case ukbanksmartbank = "케이뱅크"
    case cuonbank = "신협ON뱅크"
    
    // 기업
    case kbbiz = "KB스타기업뱅킹"
    case hanancbs = "하나은행 기업"
    case kakaob0a5afe92aad41a59f22497a2b1f6be3 = "NH기업뱅킹"
    case wooriwonbiz = "우리WON기업"
    case SmartBankWBC = "원터치 기업"
    case iphoneSbizbank = "쏠 비즈"
    case mcbs = "i-ONE뱅크 기업"
    case dgbbbanking = "DGB기업뱅킹"
    case bizsmartkdb = "스마트KDB기업"
    case suhyupbsmb = "수협뱅크기업"
    case kakaoae784afda3057dafbde4bb9da80bfdfc = "광주기업뱅킹"
    case smartsbe = "부산기업뱅킹"
    case ukbankcbzbank = "케이뱅크 기업"
}
