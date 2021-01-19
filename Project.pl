courses([(csen403,2), (csen905,2), (csen709,1), (csen601,2), (csen301,3), (csen701,2), (csen503,3), (csen501,2)]).


slots([slot(sunday,1), slot(sunday,2), slot(sunday,3), slot(monday,1), slot(monday,2), slot(monday,3), slot(tuesday,1), slot(tuesday,2), slot(tuesday,3), slot(wednesday,1), slot(wednesday,2), slot(wednesday,3)]).

		

putSlots(L):-
	slots(Slots),
	putSlotsHelper(L, Slots).

putSlotsHelper([],[]).
putSlotsHelper([(slot(Day, Slot), _)|T], [(slot(Day, Slot))|TS]):-
	putSlotsHelper(T, TS).
	

	

courseNotDone(L, S):-
		 \+member(S, L).



pickAnotDoneCourse([(C,N)|_], L, (C,N)):-
			courseNotDone(L, C).
pickAnotDoneCourse([(_,_)|T], L, R):-
			pickAnotDoneCourse(T, L, R). 




scheduleCourse(_, _, 0).
scheduleCourse([(slot(_,_), Course)|T], Course, N):-
			N>0,
			N1 is N-1,
			scheduleCourse(T, Course, N1).
					
scheduleCourse([(slot(_,_), Course)|T], X, N):- 
			N>0,
			X\=Course, 
			scheduleCourse(T, X, N).




removeFromNotDone(_, [], []).
removeFromNotDone(C, [C|T], R):-
			removeFromNotDone(C, T, R).

removeFromNotDone(C, [H|T], [H|T1]):-
			C\=H,
			removeFromNotDone(C, T, T1). 

	

schedule(_, UpdatedDoneSubjects, _, 0, DoneSubjN1):-
		length(UpdatedDoneSubjects, DoneSubjN1).

schedule(L, DoneSubjects, NotDoneSubjects, AvailableSlots, DoneSubjN):-
			pickAnotDoneCourse(NotDoneSubjects, DoneSubjects, Course),
			Course=(Name, RequiredSlots),
			RequiredSlots=<AvailableSlots,
			scheduleCourse(L, Name, RequiredSlots),
			removeFromNotDone(Course, NotDoneSubjects, UpdatedNotDoneSubjects),
			append([Course], DoneSubjects, UpdatedDoneSubjects),
			AvailableSlots1 is AvailableSlots-RequiredSlots,
			schedule(L, UpdatedDoneSubjects, UpdatedNotDoneSubjects, AvailableSlots1, DoneSubjN).
			
				
	
solve(L,DoneSubjN):-
		putSlots(L),
		length(L,N),
		courses(NotDone),
		sort(2,@=<,NotDone,SortedCourses),
		schedule(L,[],SortedCourses,N,DoneSubjN).
