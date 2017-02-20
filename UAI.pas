unit UAI;

interface

uses
  UBoard, UMove;

type
  TAI = class(TObject)
    private
      Difficulty: integer;
      MaxDepth: integer;
    public
      constructor Create(ADifficulty: integer);
      function ManualDepth(ADepth: integer): boolean;
      function Minimax(Board: TObjectArray): TMove;
      function Max():;//////do thuis
      function Min():;

  end;

implementation

end.
