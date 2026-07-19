***********************
PROCEDURE CS &&初始模块
***********************

IF ANSWER=CHR(27)  &&ESC
   RETURN
ENDIF

PUBLIC N,F,G,O  &&权数

  N=0     &&No
  F=1     &&Faded 
  G=2     &&General
  O=4     &&Obvious

PUBLIC DZ,YY,NY,DX  &&各种气质类型计数器

  DZ=0    &&胆汁质
  YY=0    &&抑郁质
  NY=0    &&粘液质
  DX=0    &&多血质

PUBLIC DZ_C,YY_C,NY_C,DX_C  &&统计各气质属性记录的记录数

  COUNT FOR QZSX="DZ" TO DZ_C 
  COUNT FOR QZSX="YY" TO YY_C
  COUNT FOR QZSX="NY" TO NY_C
  COUNT FOR QZSX="DX" TO DX_C
  GO TOP

PUBLIC COUNT1,COUNT2,QZSX,MAX,MAX1,MAX2  &&其他变量

  COUNT1=0
  COUNT2=1                    &&COUNT1,COUNT2在结论模块中将用作计数器
  QZSX1='  '                  &&QZSX1是提问模块中的临时变量
  STORE '  ' TO MAX,MAX1,MAX2 
              &&MAX,MAX1,MAX2在分析模块中将用于最占优势的气质属性

******
RETURN
******

***********************
PROCEDURE TW &&提问模块
***********************

IF ANSWER=CHR(27)  &&ESC
   RETURN
ENDIF

DO WHILE .T.

   CLEAR

   SET COLOR TO BG+/B
   @ 5,12 SAY '请您对所提出的'+STR(RECCOUNT(),3)+;
           '个问题按以下四个等级认真进行回答,谢谢!'
   SET COLOR TO G+/B
   @ 7,19 SAY '            N.没有   No;'
   @ 8,19 SAY '            F.模糊   Faded;'
   @ 9,19 SAY '            G.一般   General;'
   @10,19 SAY '            O.显著   Obvious.'
   SET COLOR TO R+/B
   @24,19 SAY ' PgUp->上翻; PgDn,Enter->下翻; Esc->结束.'
   SET COLOR TO
   DO WHILE .NOT. EOF()

      ANSWER=' '

      DO WHILE .NOT. ANSWER$("NFGO"+CHR(27))

         IF RECNO()=1
            @13,1 SAY SPACE(80)
         ELSE 
            SKIP -1
            SET COLOR TO GR+/B
            @13,1 SAY STR(RECNO(),3)+": "+ZJTD+"(N/F/G/O)."+XZBJ
                  &&显示上一条记录,方便查看.
            SET COLOR TO
            SKIP
            ENDIF

         ANSWER='N'
         @14, 1 SAY STR(RECNO(),3)+": "+ZJTD+"(N/F/G/O)?"+XZBJ
         ANSWER=UPPER(CHR(INKEY(0)))

         IF ANSWER=CHR(3) .OR. ANSWER=CHR(13)   &&下翻
            ANSWER=XZBJ
         ENDIF
         
         IF ANSWER$"NFGO"
            &&&&&&&&&&&&&&&&&&&&&&&&
            QZSX1=QZSX
            &QZSX1=&QZSX1+&ANSWER &&按回答的不同的等级进行加权,为分析统计!!!
            REPLACE XZBJ WITH ANSWER
            &&&&&&&&&&&&&&&&&&&&&&&&
         ELSE
            IF ANSWER=CHR(18) .AND. RECNO()#1   &&上翻
               SKIP -1
               LOOP
            ENDIF
         ENDIF

      ENDDO
           
      IF ANSWER=CHR(27)  &&ESC
         EXIT  
      ENDIF
      
      SKIP

   ENDDO
   
   @14, 1 SAY SPACE(80)
   
   IF RECNO()#1
      SKIP -1  
      SET COLOR TO GR+/B
      @13, 1 SAY STR(RECNO(),3)+": "+ZJTD+"(N/F/G/O)."+XZBJ   
      SET COLOR TO
      SKIP
   ENDIF
   
   ANSWER=' '
   @ 24,1 SAY SPACE(79)
   DO WHILE .NOT. ANSWER$('YN'+CHR(27)+CHR(13))
      @19,1 SAY "*****提问结束,若您的回答不慎,将对结论产生影响,"+;
                "是否复察(Y/N)?N"
      ANSWER=UPPER(CHR(INKEY(0)))
   ENDDO

   IF ANSWER='Y'
      SKIP -1
      LOOP
   ELSE
      ANSWER=' '
      EXIT           
   ENDIF

ENDDO

GO TOP

******
RETURN
******

***********************
PROCEDURE FX &&分析模块
***********************

IF ANSWER=CHR(27)  &&ESC
   RETURN
ENDIF

&&&&&&&&&&  &&除去因不同气质属性所占比例不同而带来的偏差,亦是分析!!!
DZ=DZ/DZ_C 
YY=YY/YY_C 
NY=NY/NY_C 
DX=DX/DX_C 
&&&&&&&&&&

IF DZ>YY     &&分类排序
   MAX1='DZ'
ELSE
   MAX1='YY'
ENDIF

IF NY>DX
   MAX2='NY'
ELSE
   MAX2='DX'
ENDIF

IF &MAX1>&MAX2     &&选出最占优势的,亦即此人的气质属性.
   MAX=MAX1
ELSE
   IF &MAX1=&MAX2  &&出现两种以上的气质属性占优势
      MAX="  "
   ELSE
      MAX=MAX2     
   ENDIF
ENDIF

******
RETURN
******

***********************
PROCEDURE JL &&结论模块
***********************

IF ANSWER=CHR(27)  &&ESC
   RETURN
ENDIF

CLEAR 

IF MAX="  " 

   ?'*****对不起,分析失败.'
   ?'*****可能原因:'
   ?'*****    1.被分析的人性格怪异;'
   ?'*****    2.您在回答问题上出现偏差.'
   ?'*****建议再做一次分析.'
   ANSWER=CHR(INKEY(0))

ELSE

   INDEX ON -ASC(XZBJ) TO XZBJ.IDX  
                       &&按回答的不同等级进行索引,以便更好地为结果显示分类 
   LOCATE FOR QZSX=MAX .AND. XZBJ#'N'  &&查找最占优势的记录

   DIMENSION CT(100) &&将在结论模块中用于登记选中记录的记录号
   
   DO WHILE FOUND()  &&考虑到最后一条也满足条件
      COUNT1=COUNT1+1 
      CT(COUNT1)=RECNO()  &&用数组记录查找到的记录
      CONTINUE
   ENDDO
      
   DO WHILE .T.  &&实现浏览的功能
     
      ANSWER=' '

      DO WHILE .T.
         GO CT(COUNT2)
         @ MOD(COUNT2-1,6)*4,1 SAY STR(COUNT2,5)+'('+XZBJ+').  '
         ?? DYXG
         IF MOD(COUNT2,6)=0 .OR. COUNT2=COUNT1
            EXIT
         ENDIF
         COUNT2=COUNT2+1    
      ENDDO

      SET COLOR TO R+/B
      @24,10 SAY "分析结果如上^^^^^^PgUp->上翻; PgDn,Enter->下翻; Esc->退出." 
      SET COLOR TO
         
      DO WHILE .NOT.ANSWER$(CHR(27)+CHR(3)+CHR(18)+CHR(13))
         ANSWER=CHR(INKEY(0))
      ENDDO
          
      IF ANSWER=CHR(27)  &&ESC
         EXIT
      ENDIF
      IF (ANSWER=CHR(3) .OR. ANSWER=CHR(13)) .AND. COUNT2#COUNT1 &&下翻
         CLEAR
         COUNT2=COUNT2+1
      ENDIF
      IF ANSWER=CHR(18) .AND. COUNT2>6 &&上翻
         CLEAR
         COUNT2=COUNT2-MOD(COUNT2-1,6)-6
      ENDIF
        
   ENDDO
                                
ENDIF

CLOSE INDEX     &&注意要先关闭正在使用的文件,而后可删除!!!
ERASE XZBJ.IDX  &&删除在结论模块中使用的索引文件

******
RETURN
******

RETURN