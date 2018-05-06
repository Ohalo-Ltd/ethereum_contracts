pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ValidateUTF8} from "./ValidateUTF8.slb";

/* solhint-disable max-line-length */
contract ValidateUTF8Test {

    using ValidateUTF8 for string;
    using ValidateUTF8 for uint;

    // Used to extract the memory address of the data inside a byte-array in memory.
    function _memDataPtr(bytes memory bts) private pure returns (uint ptr) {
        assembly {
            ptr := mload(add(bts, 0x20))
        }
    }

    /************************ Parsing - success *************************/

    // Size one

    function testParseRuneSizeOne() internal {
        bytes memory bts1 = hex"00";
        bytes memory bts2 = hex"7F";
        uint addr1 = _memDataPtr(bts1);
        uint addr2 = _memDataPtr(bts2);
        assert(addr1.parseRune() == 1);
        assert(addr2.parseRune() == 1);
    }

    function testValidateUTF8ParseRuneSizeOneSeveral() internal {
        bytes memory bts = hex"11007F22";
        uint addr1 = _memDataPtr(bts);
        uint addr2 = _memDataPtr(bts) + 1;
        uint addr3 = _memDataPtr(bts) + 2;
        uint addr4 = _memDataPtr(bts) + 3;
        assert(addr1.parseRune() == 1);
        assert(addr2.parseRune() == 1);
        assert(addr3.parseRune() == 1);
        assert(addr4.parseRune() == 1);
    }

    // Size two

    function testValidateUTF8ParseRuneSizeTwo() internal {
        bytes memory bts1 = hex"C280";
        bytes memory bts2 = hex"C2BF";
        bytes memory bts3 = hex"DF80";
        bytes memory bts4 = hex"DFBF";
        uint addr1 = _memDataPtr(bts1);
        uint addr2 = _memDataPtr(bts2);
        uint addr3 = _memDataPtr(bts3);
        uint addr4 = _memDataPtr(bts4);
        assert(addr1.parseRune() == 2);
        assert(addr2.parseRune() == 2);
        assert(addr3.parseRune() == 2);
        assert(addr4.parseRune() == 2);
    }

    function testValidateUTF8ParseRuneSizeTwoSeveral() internal {
        bytes memory bts = hex"DF8045C2BF22";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 2);
        assert((addr + 2).parseRune() == 1);
        assert((addr + 3).parseRune() == 2);
        assert((addr + 5).parseRune() == 1);
    }

    // Size three

    function testValidateUTF8ParseRuneSizeThreeE0() internal {
        bytes memory bts1 = hex"E0A080";
        bytes memory bts2 = hex"E0A0BF";
        bytes memory bts3 = hex"E0BF80";
        bytes memory bts4 = hex"E0BFBF";
        uint addr1 = _memDataPtr(bts1);
        uint addr2 = _memDataPtr(bts2);
        uint addr3 = _memDataPtr(bts3);
        uint addr4 = _memDataPtr(bts4);
        assert(addr1.parseRune() == 3);
        assert(addr2.parseRune() == 3);
        assert(addr3.parseRune() == 3);
        assert(addr4.parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeE0Several() internal {
        bytes memory bts = hex"E0A08024E0A0BFC2BFE0BF80E0BFBF";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 1);
        assert((addr + 4).parseRune() == 3);
        assert((addr + 7).parseRune() == 2);
        assert((addr + 9).parseRune() == 3);
        assert((addr + 12).parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeE1toEC() internal {
        bytes memory bts = hex"E18080";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"E180BF";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"E1BF80";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"E1BFBF";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EC8080";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EC80BF";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"ECBF80";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"ECBFBF";
        assert(_memDataPtr(bts).parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeE1toECSeveral() internal {
        bytes memory bts = hex"E1BF80E4A088E9BF80EC9491";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 3);
        assert((addr + 6).parseRune() == 3);
        assert((addr + 9).parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeED() internal {
        bytes memory bts1 = hex"ED8080";
        bytes memory bts2 = hex"ED80BF";
        bytes memory bts3 = hex"ED9F80";
        bytes memory bts4 = hex"ED9FBF";
        uint addr1 = _memDataPtr(bts1);
        uint addr2 = _memDataPtr(bts2);
        uint addr3 = _memDataPtr(bts3);
        uint addr4 = _memDataPtr(bts4);
        assert(addr1.parseRune() == 3);
        assert(addr2.parseRune() == 3);
        assert(addr3.parseRune() == 3);
        assert(addr4.parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeEDSeveral() internal {
        bytes memory bts = hex"ED87A0ED90AFED9EBBED8A9A";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 3);
        assert((addr + 6).parseRune() == 3);
        assert((addr + 9).parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeEEtoEF() internal {

        bytes memory bts = hex"EE8080";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EE80BF";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EEBF80";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EEBFBF";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EF8080";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EF80BF";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EFBF80";
        assert(_memDataPtr(bts).parseRune() == 3);

        bts = hex"EFBFBF";
        assert(_memDataPtr(bts).parseRune() == 3);
    }

    function testValidateUTF8ParseRuneSizeThreeEEtoEFSeveral() internal {
        bytes memory bts = hex"EEBF80EFA088EFBF80EE9491";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 3);
        assert((addr + 3).parseRune() == 3);
        assert((addr + 6).parseRune() == 3);
        assert((addr + 9).parseRune() == 3);
    }

    // Size four

    function testValidateUTF8ParseRuneSizeFourF0() internal {
        bytes memory bts = hex"F0908080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F09080BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F090BF80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F090BFBF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F0BF8080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F0BF80BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F0BFBF80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F0BFBFBF";
        assert(_memDataPtr(bts).parseRune() == 4);
    }

    function testValidateUTF8ParseRuneSizeThreeF0Several() internal {
        bytes memory bts = hex"F09FA680F09FA780F09FA68BF09FA691";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 4);
        assert((addr + 4).parseRune() == 4);
        assert((addr + 8).parseRune() == 4);
        assert((addr + 12).parseRune() == 4);
    }

    function testValidateUTF8ParseRuneSizeFourF1() internal {
        bytes memory bts = hex"F1808080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F18080BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F180BF80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F180BFBF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F1BF8080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F1BF80BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F1BFBF80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F1BFBFBF";
        assert(_memDataPtr(bts).parseRune() == 4);
    }

    function testValidateUTF8ParseRuneSizeFourF3() internal {
        bytes memory bts = hex"F3808080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F38080BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F380BF80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F380BFBF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F3BF8080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F3BF80BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F3BFBF80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F3BFBFBF";
        assert(_memDataPtr(bts).parseRune() == 4);
    }

    function testValidateUTF8ParseRuneSizeThreeF1toF3Several() internal {
        bytes memory bts = hex"F3808080F2BF80BFF1BF8080F1BFBFBF";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 4);
        assert((addr + 4).parseRune() == 4);
        assert((addr + 8).parseRune() == 4);
        assert((addr + 12).parseRune() == 4);
    }

    function testValidateUTF8ParseRuneSizeFourF4() internal {

        bytes memory bts = hex"F4808080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F48080BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F4808F80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F4808FBF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F48F8080";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F48F80BF";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F48F8F80";
        assert(_memDataPtr(bts).parseRune() == 4);

        bts = hex"F48F8FBF";
        assert(_memDataPtr(bts).parseRune() == 4);
    }

    function testValidateUTF8ParseRuneSizeThreeF4Several() internal {
        bytes memory bts = hex"F48080BFF4808F80F48F80BFF48F8FBF";
        uint addr = _memDataPtr(bts);
        assert(addr.parseRune() == 4);
        assert((addr + 4).parseRune() == 4);
        assert((addr + 8).parseRune() == 4);
        assert((addr + 12).parseRune() == 4);
    }

    /************************ Parsing - fails *************************/

    // 1 byte characters

    function testValidateUTF8ParseRuneThrows1FBHigh() internal {
        bytes memory bts = hex"80";
        _memDataPtr(bts).parseRune();
    }

    // 2 byte characters

    function testValidateUTF8ParseRuneThrows2FBLow() internal {
        bytes memory bts = hex"C180";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows2SBLow() internal {
        bytes memory bts = hex"C479";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows2FBHigh() internal {
        bytes memory bts = hex"C1C0";
        _memDataPtr(bts).parseRune();
    }

    // 3 byte characters

    function testValidateUTF8ParseRuneThrows3E0SBLow() internal {
        bytes memory bts = hex"E09980";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E0SBHigh() internal {
        bytes memory bts = hex"E0C080";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E0TBLow() internal {
        bytes memory bts = hex"E0A17F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E0TBHigh() internal {
        bytes memory bts = hex"E0A1C0";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E1toECSBLow() internal {
        bytes memory bts = hex"E37F80";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E1toECSBHigh() internal {
        bytes memory bts = hex"E3C080";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E1toECTBLow() internal {
        bytes memory bts = hex"E3BF7F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3E1toECTBHigh() internal {
        bytes memory bts = hex"E3BFC0";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EDSBLow() internal {
        bytes memory bts = hex"ED7F80";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EDSBHigh() internal {
        bytes memory bts = hex"EDA080";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EDTBLow() internal {
        bytes memory bts = hex"ED9F7F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EDTBHigh() internal {
        bytes memory bts = hex"ED9FC0";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EEtoEFSBLow() internal {
        bytes memory bts = hex"EE7F80";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EEtoEFSBHigh() internal {
        bytes memory bts = hex"EEC080";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EEtoEFTBLow() internal {
        bytes memory bts = hex"EEBF7F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows3EEtoEFTBHigh() internal {
        bytes memory bts = hex"EEBFC0";
        _memDataPtr(bts).parseRune();
    }

    // 4 byte characters

    function testValidateUTF8ParseRuneThrows4F0SBLow() internal {
        bytes memory bts = hex"F08F80BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F0SBHigh() internal {
        bytes memory bts = hex"F0C080BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F0TBLow() internal {
        bytes memory bts = hex"F0807FBF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F0TBHigh() internal {
        bytes memory bts = hex"F080C0BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F0FBLow() internal {
        bytes memory bts = hex"F080BF7F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F0FBHigh() internal {
        bytes memory bts = hex"F080BFC0";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F1toF3SBLow() internal {
        bytes memory bts = hex"F27F80BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F1toF3SBHigh() internal {
        bytes memory bts = hex"F2C080BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F1toF3TBLow() internal {
        bytes memory bts = hex"F2807FBF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F1toF3TBHigh() internal {
        bytes memory bts = hex"F280C0BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F1toF3FBLow() internal {
        bytes memory bts = hex"F280BF7F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F1toF3FBHigh() internal {
        bytes memory bts = hex"F280BFC0";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F4SBLow() internal {
        bytes memory bts = hex"F47F80BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F4SBHigh() internal {
        bytes memory bts = hex"F49080BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F4TBLow() internal {
        bytes memory bts = hex"F4807FBF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F4TBHigh() internal {
        bytes memory bts = hex"F480C0BF";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F4FBLow() internal {
        bytes memory bts = hex"F480BF7F";
        _memDataPtr(bts).parseRune();
    }

    function testValidateUTF8ParseRuneThrows4F4FBHigh() internal {
        bytes memory bts = hex"F480BFC0";
        _memDataPtr(bts).parseRune();
    }

    /************************* Validate ***************************/

    function testValidateUTF8ValidateNull() internal {
        string memory str = "";
        str.validate();
    }

    function testValidateUTF8ValidateRunePoem() internal {
        string memory str = "ᚠᛇᚻ᛫ᛒᛦᚦ᛫ᚠᚱᚩᚠᚢᚱ᛫ᚠᛁᚱᚪ᛫ᚷᛖᚻᚹᛦᛚᚳᚢᛗ ᛋᚳᛖᚪᛚ᛫ᚦᛖᚪᚻ᛫ᛗᚪᚾᚾᚪ᛫ᚷᛖᚻᚹᛦᛚᚳ᛫ᛗᛁᚳᛚᚢᚾ᛫ᚻᛦᛏ᛫ᛞᚫᛚᚪᚾ ᚷᛁᚠ᛫ᚻᛖ᛫ᚹᛁᛚᛖ᛫ᚠᚩᚱ᛫ᛞᚱᛁᚻᛏᚾᛖ᛫ᛞᚩᛗᛖᛋ᛫ᚻᛚᛇᛏᚪᚾ";
        str.validate();
    }

    function testValidateUTF8ValidateBrut() internal {
        string memory str = "An preost wes on leoden, Laȝamon was ihoten He wes Leovenaðes sone -- liðe him be Drihten. He wonede at Ernleȝe at æðelen are chirechen, Uppen Sevarne staþe, sel þar him þuhte, Onfest Radestone, þer he bock radde.";
        str.validate();
    }

    function testValidateUTF8ValidateOdysseusElytis() internal {
        string memory str = "Τη γλώσσα μου έδωσαν ελληνική το σπίτι φτωχικό στις αμμουδιές του Ομήρου. Μονάχη έγνοια η γλώσσα μου στις αμμουδιές του Ομήρου. από το Άξιον Εστί του Οδυσσέα Ελύτη";
        str.validate();
    }

    function testValidateUTF8ValidatePushkinsHorseman() internal {
        string memory str = "На берегу пустынных волн Стоял он, дум великих полн, И вдаль глядел. Пред ним широко Река неслася; бедный чёлн По ней стремился одиноко. По мшистым, топким берегам Чернели избы здесь и там, Приют убогого чухонца; И лес, неведомый лучам В тумане спрятанного солнца, Кругом шумел.";
        str.validate();
    }

    function testValidateUTF8ValidateKnightInTigerSkin() internal {
        string memory str = "ვეპხის ტყაოსანი შოთა რუსთაველი ღმერთსი შემვედრე, ნუთუ კვლა დამხსნას სოფლისა შრომასა, ცეცხლს, წყალსა და მიწასა, ჰაერთა თანა მრომასა; მომცნეს ფრთენი და აღვფრინდე, მივჰხვდე მას ჩემსა ნდომასა, დღისით და ღამით ვჰხედვიდე მზისა ელვათა კრთომაასა.";
        str.validate();
    }

    function testValidateUTF8ValidateQuickBrownFoxHebrew() internal {
        string memory str = "זה כיף סתם לשמוע איך תנצח קרפד עץ טוב בגן";
        str.validate();
    }

    function testValidateUTF8ValidateQuickBrownFoxHiragana() internal {
        string memory str = "いろはにほへど　ちりぬるを わがよたれぞ　つねならむ うゐのおくやま　けふこえて あさきゆめみじ　ゑひもせず";
        str.validate();
    }

}
/* solhint-enable max-line-length */