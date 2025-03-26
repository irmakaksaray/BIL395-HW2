with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers; 
with Ada.Containers.Ordered_Maps;

procedure Main is

   package String_Maps is new Ada.Containers.Ordered_Maps
     (Key_Type => String,
      Element_Type => Integer);
   use String_Maps;

   Vars : String_Maps.Map;

   Line : String (1 .. 100);
   Last : Natural;

   function Trim(S : String) return String is
      First : Natural := S'First;
      Last_Char : Natural := S'Last;
   begin
      while First <= S'Last and then S(First) = ' ' loop
         First := First + 1;
      end loop;
      while Last_Char >= First and then S(Last_Char) = ' ' loop
         Last_Char := Last_Char - 1;
      end loop;
      return S(First .. Last_Char);
   end Trim;

   procedure Eval(Input : String) is
      Name  : String (1 .. 50);
      Value : Integer;
      Pos   : Natural;
      Left  : String (1 .. 50);
      Right : String (1 .. 50);
   begin
      if Input = "exit" then
         -- Çıkış
         raise Program_Error;
      elsif Input(1 .. 5) = "print" then
         declare
            Varname : String := Trim(Input(6 .. Input'Last));
         begin
            if Vars.Contains(Varname) then
               Put_Line(Integer'Image(Vars(Varname)));
            else
               Put_Line("Tanımsız değişken.");
            end if;
         end;
      elsif Input'Length > 1 and then Input(Index => 2) = ':' then
         -- x := 5
         Pos := Index(Input, ":=");
         if Pos = 0 then
            Put_Line("Hatalı atama.");
         else
            Left  := Trim(Input(1 .. Pos - 1));
            Right := Trim(Input(Pos + 2 .. Input'Last));
            declare
               Val : Integer;
            begin
               Val := Integer'Value(Right);
               Vars.Insert(Left, Val);
               Put_Line(Left & " = " & Integer'Image(Val));
            exception
               when others =>
                  Put_Line("Hatalı değer.");
            end;
         end if;
      else
         -- x + 3
         declare
            A, B : Integer;
            Op : Character;
            Mid : Natural := 0;
         begin
            for I in Input'Range loop
               if Input(I) = '+' or Input(I) = '-' or Input(I) = '*' or Input(I) = '/' then
                  Mid := I;
                  exit;
               end if;
            end loop;

            if Mid = 0 then
               Put_Line("Geçersiz ifade.");
            else
               Left  := Trim(Input(1 .. Mid - 1));
               Right := Trim(Input(Mid + 1 .. Input'Last));
               Op := Input(Mid);

               if Vars.Contains(Left) then
                  A := Vars(Left);
               else
                  A := Integer'Value(Left);
               end if;

               if Vars.Contains(Right) then
                  B := Vars(Right);
               else
                  B := Integer'Value(Right);
               end if;

               declare
                  Result : Integer;
               begin
                  case Op is
                     when '+' => Result := A + B;
                     when '-' => Result := A - B;
                     when '*' => Result := A * B;
                     when '/' =>
                        if B = 0 then
                           Put_Line("Sıfıra bölme hatası.");
                           return;
                        else
                           Result := A / B;
                        end if;
                     when others =>
                        Put_Line("Bilinmeyen işlem.");
                        return;
                  end case;
                  Put_Line("Result: " & Integer'Image(Result));
               end;
            end if;
         exception
            when others =>
               Put_Line("Hata oluştu.");
         end;
      end if;
   end Eval;

begin
   Put_Line("Çıkmak için 'exit' yazın.");
   loop
      Put(">> ");
      Get_Line(Line, Last);
      declare
         Input : constant String := Trim(Line(1 .. Last));
      begin
         Eval(Input);
      exception
         when Program_Error =>
            exit;
      end;
   end loop;
end Main;
