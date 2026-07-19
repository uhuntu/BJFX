************
*主程序开始*
************

SET TALK OFF
SET ESCAPE OFF
SET SAFE OFF
SET DECIMAL TO 5
ON ERROR ??

CLEAR
CLEAR ALL
CLOSE ALL

SET COLOR TO GR+/B
@ 9,29 SAY ' 欢迎使用笔迹分析系统'
@10,29 SAY '       版本1.0'

@12,29 SAY '     设计者:林恒'
@13,29 SAY '    指导人:金一贵'
@14,29 SAY '参考书目:《笔迹与性格》'
SET COLOR TO
?
?
? '*****按任意键继续......'
ANSWER=CHR(INKEY(0)) 
CLEAR

USE BJFX.DBF
COPY TO BJFXTMP.DBF  &&由于不能对编译后的数据库进行修改,
USE BJFXTMP.DBF      &&故要建立一个临时文件以便修改.
REPLACE ALL XZBJ WITH 'N'
GO TOP

DO WHILE .T.

*************************
SET PROCEDURE TO BJFXPROC

DO CS &&初始模块

DO TW &&提问模块

DO FX &&分析模块

DO JL &&结论模块

SET PROCEDURE TO
*************************

REPLACE ALL XZBJ WITH 'N'
GO TOP

CLEAR
CLEAR MEMORY
ANSWER=' '

DO WHILE .NOT. ANSWER$('YN'+CHR(27)+CHR(13))

   @5,1 SAY '*****是否还要再作一次分析(Y/N)?Y'
   ANSWER=UPPER(CHR(INKEY(0)))

ENDDO

IF ANSWER='Y' .OR. ANSWER=CHR(13) 
   LOOP
ELSE
   EXIT
ENDIF
 
ENDDO

USE
ERASE BJFXTMP.DBF

CLEAR

SET COLOR TO GR+/B
@ 10,25 SAY "      谢谢使用本系统, 再见.     "
@ 11,25 SAY "(Copyright by Hunt Lin, Xiamen.)"
SET COLOR TO

?
?
? '*****按任意键退出.'
ANSWER=CHR(INKEY(0)) 

CLEAR
CLEAR ALL
CLOSE ALL
ON ERROR
SET DECIMAL TO 2
SET SAFE ON
SET ESCAPE ON
SET TALK ON


RETURN

************
*主程序结束*
************
