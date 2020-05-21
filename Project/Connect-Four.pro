?- 
   G_Player := 1,
   G_Game_over := 0,
   G_Filled_squares := 0,
   G_Last_move := 0,
   array(grid, 42, 0),
   window( title("Connect Four, Blue Player's turn"), size(500, 490), 
	class(win_func), paint_indirectly).
   
win_func(paint) :- 
   pen(2, rgb(0, 0, 0)),  
   line(30, 60, 30, 420),
   line(30, 420, 450, 420),
   line(450, 420, 450, 60),
   line(450, 60, 30, 60),
   line(90, 60, 90, 420),
   line(150, 60, 150, 420),
   line(210, 60, 210, 420),
   line(270, 60, 270, 420),
   line(330, 60, 330, 420),
   line(390, 60, 390, 420),
   line(30, 120, 450, 120),
   line(30, 180, 450, 180),
   line(30, 240, 450, 240),
   line(30, 300, 450, 300),
   line(30, 360, 450, 360),
   Arrow is bitmap_image("arrow-down.bmp", _),
   draw_bitmap(40, 10, Arrow, _, _),
   draw_bitmap(100, 10, Arrow, _, _),
   draw_bitmap(160, 10, Arrow, _, _),
   draw_bitmap(220, 10, Arrow, _, _),
   draw_bitmap(280, 10, Arrow, _, _),
   draw_bitmap(340, 10, Arrow, _, _),
   draw_bitmap(400, 10, Arrow, _, _),
   draw_circles.

win_func(mouse_click(X, Y)) :-
    G_Game_over=:=0,
   (X>=30, X=<450, Y>=0, Y=<60),
   (X>=30, X=<90 -> Col:=0 else (
		X>90, X<150 -> Col:=1 else (
			X>=150, X=<210 -> Col:=2 else (
				X>210, X<270 -> Col:=3 else (
					X>=270, X=<330 -> Col:=4 else (
						X>330, X<390 -> Col:=5 else
										Col:=6
   )))))),
   put_circle(Col),
   win_func(paint),
   (check_win; think).

draw_circles :-
   for(I, 0, 41),
	(I>34 -> Y := 390 else
		(I>27 -> Y:= 330 else 
      		(I>20 -> Y := 270 else
    				(I>13 -> Y := 210 else
             			(I>6 -> Y := 150 else
                        	 	  Y:= 90
      ))))),
	 Col:=(I mod 7) + 1,
      X:=(Col*60),
      grid(I)>0,
  	 (grid(I)=:=1 -> (
			brush(rgb(0,0,255))	
		) else
		(brush(rgb(255,0,0))
      )),
	  X1 := X-20, Y1 := Y-20, X2 := X+20, Y2 := Y+20,
	  ellipse(X1, Y1, X2, Y2),
   fail.
draw_circles.

put_circle(Col) :-
	G_Last_Move := Col,
	for(I, 35, 0, Step(-7)),
		grid(I+Col)=:=0,
		grid(I+Col):=G_Player,
		!,
		G_Player:=(G_Player=:=1 -> 2 else 1),
		(G_Player=:=1 -> 
			set_text("Connect Four, Blue Player's turn", _) else 
			set_text("Connect Four, Red Player's turn", _)),
		update_window(_).

check_win:-
	G_Filled_squares := G_Filled_squares+1,
	for(I, 0, 41),
	  grid(I)>0,
	  (
		((I mod 7)>=0, (I mod 7)=<3, grid(I+1)=:=grid(I), 
		  grid(I+2)=:=grid(I), grid(I+3)=:=grid(I)); 
		(I>=0, I=<20, grid(I+7)=:=grid(I),
		  grid(I+14)=:=grid(I), grid(I+21)=:=grid(I));
		(((I>=3, I=<6); (I>=10, I=<13); (I>=17, I=<20)), 
		  grid(I+6)=:=grid(I), grid(I+12)=:=grid(I),
		  grid(I+18)=:=grid(I));
		(((I>=0, I=<3); (I>=7, I=<10); (I>=14, I=<17)),
		  grid(I+8)=:=grid(I), grid(I+16)=:=grid(I),
		  grid(I+24)=:=grid(I))
	  ),
	  G_Game_over:=1,
      (grid(I)=:=1 -> (
	  	message("", "Blue wins!", i),
		set_text("Connect Four, Blue won!", _),
		update_window(_)
	  ) else (
		message("", "Red wins!", i),
		set_text("Connect Four, Red won!", _),
		update_window(_)
	  )), !, true.
check_win:-
	G_Filled_squares=:=42,
	G_Game_over:=1,
	message("", "It's a tie!", i),
	set_text("Connect Four, It's a tie!", _),
	update_window(_).

think:-
	repeat,
		% 2 out of 5 times AI will choose the same column as you
		% 2 out of 5 times AI will choose a column next to yours
		% 1 out of 5 times AI will choose a random column
		T:=random(5),
		((T=:=0;T=:=1) -> Col:=G_Last_Move else (
			(T=:=2;T=:=3) -> (
				(G_Last_Move=:=0, Col:=1);
				(G_Last_Move=:=6, Col:=5);
				(random(2)=:=0 -> Col:=G_Last_Move-1 else Col:=G_Last_Move+1)
						) else (
				Col:=random(7)
		))),
		(grid(Col)=\=0 -> fail else
			(put_circle(Col), !)).