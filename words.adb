with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions;
with Word_Lists;
with Ada.Strings.Maps;
with Ada.Characters.Handling;

procedure Words is
	-- Constant
	Instruction : constant String := "-i";
	-- Types
	Type Tipo_Election is (Most_Frequent_Word , Interactive, Nothing);
	-- Renames
	package T_IO renames Ada.Text_IO;
	package C_L renames Ada.Command_Line;
	package ASU renames Ada.Strings.Unbounded;
	package AI_E renames Ada.IO_Exceptions;
	package W_L renames Word_Lists;
-------------------------------------------------------------------------------
	procedure Know_Election(Election : in out Tipo_Election) is
		function Conditions_for_MFW return Boolean is
		begin -- Conditions_for_MFW
			return C_L.Argument_Count = 1 and then C_L.Argument(1) /= Instruction;
		end Conditions_for_MFW;
		function Conditions_for_Interactive return Boolean is
		begin -- Conditions_for_Interactive
			return C_L.Argument_Count = 2 and then C_L.Argument(1) = Instruction;
		end Conditions_for_Interactive;	
		Bad_Argument : exception;

	begin -- Know_Election
		if Conditions_for_MFW  then
			Election := Most_Frequent_Word;
		elsif Conditions_for_Interactive then
			Election := Interactive;
		else
			raise Bad_Argument;				
		end if;
		exception
			when Bad_Argument =>
				T_IO.Put_Line("usage: words [-i] <filename>");
	end Know_Election;
-------------------------------------------------------------------------------
	-------------------------COMUN PROCEDURES-----------------------------

	procedure Descompose_File(File : in out T_IO.File_Type; List : in out W_L.Word_List_Type) is
		procedure Descompose_Line(Line : in out ASU.Unbounded_String; List: in out W_L.Word_List_Type) is
			procedure Delete_Space(Line :in out ASU.Unbounded_String) is
				C: Character;
				Finish : Boolean:= False;
			begin -- Delete_Space
				if not (ASU.Length(Line) = 0) then
					while not Finish loop
						C := ASU.To_String(Line)(1);
						if (c = ' ') then
							ASU.Tail(Line, ASU.Length(Line) - 1);
						end if;
						if not (ASU.Length(Line) = 0) then
							C := ASU.To_String(Line)(1);
							Finish := not (C = ' ');
						else
							Finish := True;
						end if;
					end loop;
				end if;
			end Delete_Space;

			I: Integer;
			End_Line : Boolean := False;
			Last_Word : Boolean;
			Format_Error : exception;
			Word : ASU.Unbounded_String;
		begin -- Descompose_Line
			while not End_Line loop
				Delete_Space(Line);
				I := ASU.Index(Line, Ada.Strings.Maps.To_Set(" ?:!;()""'|_,.-"));
				End_Line := ASU.Length(Line) = 0;
				Last_Word := I=0;
				if not End_Line then
					begin
						if Last_Word then
							Word := Line;
							End_Line := True;
						else
							Word := ASU.Head(Line, I-1);
							ASU.Tail(Line, ASU.Length(Line) - I);
						end if;
						if ASU.Length(Word) /= 0 then
							W_L.Add_Word(List, Word);
						end if;
					end;
				end if;
			end loop;
		end Descompose_Line;

		End_File : Boolean:= False;
		Line : ASU.Unbounded_String;
	begin -- Descompose_File
		while not End_File loop
			begin
				Line := ASU.To_Unbounded_String(T_IO.Get_Line(File));
				Line:=ASU.To_Unbounded_String(Ada.Characters.Handling.To_Lower(ASU.To_String(Line)));	
				Descompose_Line(Line, List);
				exception
					when Ada.IO_Exceptions.End_Error =>
						End_File := True;
			end;
		end loop;	
	end Descompose_File;
	--------------------------------------------------------------------------
	procedure Max_Word(List: in W_L.Word_List_Type) is
		Word: ASU.Unbounded_String;
		Count : Natural;
	begin -- Max_Word
		T_IO.New_Line(1);
		W_L.Max_Word(List,Word,Count);
		T_IO.Put("The most Frequent Word: ");
		T_IO.Put_Line("|" & ASU.To_String(Word) & "| - " & Integer'Image(Count));
		exception
			when W_L.Word_List_Error =>
				T_IO.Put_Line("No Words");
	end Max_Word;
-------------------------------------------------------------------------------
	procedure Show_Most_Frequent_Word(File : in out T_IO.File_Type) is
	Line: ASU.Unbounded_String;
	File_Name : ASU.Unbounded_String;
	List : W_L.Word_List_Type;
	begin -- Show_Most_Frequent_Word
		File_Name := Asu.To_Unbounded_String(C_L.Argument(1));
		T_IO.Open(File , T_IO.In_File ,ASU.To_String(File_Name));
		Descompose_File(File, List);
		Max_Word(List);
		W_L.Delete_List(List);
		T_IO.Close(File);
		T_IO.New_Line(2);
		exception
			when AI_E.Name_Error =>
				T_IO.Put_Line(C_L.Argument(1) & ": File not found");
	end Show_Most_Frequent_Word;
----------------------------INTERACTIVE----------------------------------------
	procedure Mode_Interactive(File : in out T_IO.File_Type) is
		
		Num_Options : constant Integer := 5;
		subtype Type_Range_Options is Integer range 1..Num_Options;
		type Type_Options is array (Type_Range_Options) of ASU.Unbounded_String;
		
		procedure Inicializate_Options(Options: in out Type_Options) is
		begin -- Inicializate_Options
			Options := (ASU.To_Unbounded_String("Add word"),
			ASU.To_Unbounded_String("Delete word"),
			ASU.To_Unbounded_String("Search word"),
			ASU.To_Unbounded_String("Show all words"),
			ASU.To_Unbounded_String( "Quit"));
		end Inicializate_Options;
		
		procedure Show_Options(Options: Type_Options) is
		begin -- Show_Options
			T_IO.Put_Line("Options");
			for Indice2 in Type_Range_Options loop
				T_IO.Put_Line(Integer'Image(Indice2)& " " & ASU.To_String(Options(Indice2)));
			end loop;
			T_IO.New_Line;
		end Show_Options;

		Election : Type_Range_Options:= 1;
		Wrong_Election : exception;

		function Number_of_Options(Options: Type_Options) return Type_Range_Options is	
			N :Integer;
		begin -- Number_of_Options
			T_IO.Put("Your option? ");
			N := Type_Range_Options'Value(T_IO.Get_Line);
			return N;
			exception
				when others =>
					raise Wrong_Election;
		end Number_of_Options;
		
		procedure Do_Election(Election : in Type_Range_Options; List : in out W_L.Word_List_Type) is
			Word : ASU.Unbounded_String;
			function Word_Asked return ASU.Unbounded_String  is
				Word : ASU.Unbounded_String;
			begin -- Word_Asked
				T_IO.Put("Word ? ");
				Word := ASU.To_Unbounded_String(T_IO.Get_Line);
				Word:=ASU.To_Unbounded_String(Ada.Characters.Handling.To_Lower(ASU.To_String(Word)));
				return Word;
			end Word_Asked;
			Count : Natural;
		begin -- Do_Election
			case Election is
				when 1 =>
					Word := Word_Asked;
					if ASU.To_String(Word) /= " " and then ASU.Length(Word) /= 0 then
						W_L.Add_Word(List, Word);
						T_IO.Put_Line("|"& ASU.To_String(Word) & "| added");
					end if;
				when 2 =>
					Word := Word_Asked;
					begin
						W_L.Delete_Word(List, Word);
						T_IO.Put_Line("|"& ASU.To_String(Word) &"|" & " deleted");
					exception
						when W_L.Word_List_Error =>
							T_IO.Put_Line(ASU.To_String(Word) & ": doesn't exist");
					end;
				when 3 =>
					Word := Word_Asked;
					W_L.Search_Word(List, Word, Count);
					T_IO.Put_Line("|" & ASU.To_String(Word) & "| - " & Integer'Image(Count));
				when 4 =>
					begin
						W_L.Print_All(List);
					exception
						when W_L.Word_List_Error =>
							T_IO.Put_Line("No Words");
					end;
				when 5 =>
					Max_Word(List);
			end case;
			T_IO.New_Line(2);
		end Do_Election;
		Options : Type_Options;
		File_Name : ASU.Unbounded_String;
		List : W_L.Word_List_Type;
	begin -- Mode_Interactive
		begin
			T_IO.New_Line(1);
			File_Name := ASU.To_Unbounded_String(C_L.Argument(2));
			T_IO.Open(File , T_IO.In_File ,ASU.To_String(File_Name));
			Descompose_File(File, List);
			T_IO.Close(File);		
			exception
				when AI_E.Name_Error =>
					T_IO.Put_Line(C_L.Argument(2) & ": File not found");
		end;
		Inicializate_Options(Options);
		while Election /= 5 loop
			Show_Options(Options);
			T_IO.New_Line(1);
			Election := Number_of_Options(Options);
			Do_Election(Election, List);
		end loop;
		W_L.Delete_List(List);
		exception
			when Wrong_Election =>
				T_IO.Put_Line("Better use a number between 1..5");
				Mode_Interactive(File);
	end Mode_Interactive;
-------------------------------------------------------------------------------
	Election : Tipo_Election:= Nothing;
	File : T_IO.File_Type;
begin -- Words
	Know_Election(Election);
	if Election = Interactive then
		Mode_Interactive(File);
	elsif Election = Most_Frequent_Word then
		Show_Most_Frequent_Word(File);
	end if;
end Words;
