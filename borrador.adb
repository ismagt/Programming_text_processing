		-- constantes
		Num_Max_Letters : constant Integer:= 100;
		-- tipos
		subtype Type_Range_Word is Integer range 1..Num_Max_Letters;
		type Type_Word is record
			Letters: String(Type_Range_Word);
			Length : Natural;
		end record;

		--function
		function Finish_Word(C: in Character) return Boolean is
			Finish_Word: Boolean;
			function Is_White(C:in Character) return Boolean is
			begin -- Is_White
				return not (c in 'a'..'z') and not (c in 'A'..'Z');	
			end Is_White;
		begin -- Finish_Word
			if Is_White(C) then
				Finish_Word := True;
			end if;
		return Finish_Word;
		end Finish_Word;
		function Separate_Words(Line : in ASU.Unbounded_String) return T_IO.File_Type is
			procedure Read_Word(Line: in ASU.Unbounded_String ; Word: in out Type_Word) is
				C: Character;
				Finish : Boolean := False;
			begin
				Word.Length := 0;
				while not Finish loop
					T_IO.Get(C);
					Word.Length :=	Word.Length + 1;
					Word.Letters(Word.Length) := C;
					Finish := Finish_Word(C);
				end loop;
			end Read_Word;

			Word: Type_Word;
			WordList : T_IO.File_Type;
		begin -- Separate_Words
			Read_Word(Line, Word);
			return WordList;
		end Separate_Words;
