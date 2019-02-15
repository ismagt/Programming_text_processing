with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Word_Lists is
	package T_IO renames Ada.Text_IO;
	procedure Add_Word(List :in out Word_List_Type; Word : in ASU.Unbounded_String) is
		Found : Boolean;
		P_Aux, P_New: Word_List_Type;
	begin -- Add_Word
		P_Aux := Null;
		P_New := Null;
		Found := False;
		P_Aux := List;
		while P_Aux/= Null and not Found loop
			Found := ASU.To_String(P_Aux.Word) = ASU.To_String(Word);
			if Found then
				P_Aux.Count := P_Aux.Count + 1;
			else
				P_Aux := P_Aux.Next;
			end if;
		end loop;

		if not Found then
			P_New := new Cell'(Word, 1, Null);
			if List = Null then
				List := P_New;
			else 
				P_Aux := List;
				while P_Aux.Next /= Null loop
					P_Aux := P_Aux.Next;
				end loop;
				P_Aux.Next := P_New;
			end if;
		end if;
	end Add_Word;

	procedure Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type);	 							

	procedure Delete_Word(List : in out Word_List_Type; Word: in ASU.Unbounded_String) is
		P_Next,P_Prev : Word_List_Type;
		Found : Boolean;
	begin -- Delete_Word
		Found := False;
		P_Next := List;
		P_Prev := Null;
		if not (List = Null) then
			if ASU.To_String(List.Word) = ASU.To_String(Word) then
				P_Next := P_Next.Next;
				P_Prev := List;
				Free(P_Prev);
				List := P_Next;
			else-- isnt at first postition
				while not Found and P_Next /= Null loop
					Found := ASU.To_String(P_Next.Word) = ASU.To_String(Word);
					if Found then
						P_Next := P_Next.Next;
						Free(P_Prev.Next);
						P_Prev.Next := P_Next;
					else
						P_Prev := P_Next;
						P_Next := P_Next.Next;
					end if;
				end loop;
				if not Found then	
					raise Word_List_Error;					
				end if;
			end if;
		else
			raise Word_List_Error;					
		end if;

	end Delete_Word;
	
	procedure Search_Word (List : in Word_List_Type; Word: in ASU.Unbounded_String;
							Count: out Natural) is
		Found: Boolean;
		P_Aux: Word_List_Type;
	begin -- Search_Word
		Count := 0;
		P_Aux := List;
		Found := False;
		while P_Aux /= Null and  not Found loop
			Found := ASU.To_String(P_Aux.Word) = ASU.To_String(Word);
			if not Found then
				P_Aux := P_Aux.Next;
			end if;
		end loop;
		if Found then
			Count := P_Aux.Count;
		end if;
	end Search_Word;
	procedure Max_Word (List : in Word_List_Type; Word: out ASU.Unbounded_String;
							Count: out Natural) is
		P_Aux : Word_List_Type;
	begin -- Max_Word
		Count := 0;
		P_Aux := List;
		if List = Null then
			raise Word_List_Error;
		end if;
		while P_Aux /= Null loop
			if Count < P_Aux.Count then
				Count := P_Aux.Count;
				Word := P_Aux.Word;
			else
				P_Aux := P_Aux.Next;
			end if;
		end loop;
	end Max_Word;
   
	procedure Print_All(List : in Word_List_Type) is
		P_Aux: Word_List_Type;
	begin -- Print_All
		P_Aux := List;
		if P_Aux = Null then
			raise Word_List_Error;
		else
			while P_Aux /= Null loop
				T_IO.Put_Line("|" & ASU.To_String(P_Aux.Word) & "|" & Integer'Image(P_Aux.Count));
				P_Aux := P_Aux.Next;		
			end loop;	
		end if;
	end Print_All;
  
	procedure Delete_List (List: in out Word_List_Type) is
		P_Aux: Word_List_Type;
	begin
		while List /=Null loop
			P_Aux := List.Next;
			Delete_Word(List, List.Word);
			List := P_Aux;
		end loop;
	end Delete_List;
end Word_Lists;

