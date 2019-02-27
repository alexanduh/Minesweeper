

import de.bezier.guido.*;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 20;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );

    //your code to initialize buttons goes here
    buttons  = new MSButton[NUM_ROWS][NUM_COLS];    
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r, c);
    bombs = new ArrayList<MSButton>();
    while(bombs.size() < NUM_BOMBS)
        setBombs();
    //System.out.println(bombs);
}
public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col]))
        bombs.add(buttons[row][col]);
}   

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int ct = 0;
    for(MSButton bomb : bombs) {
        if(bomb.isMarked()) {
            ct++;
            //System.out.println(ct);
        if(ct == NUM_BOMBS)
            return true;
        }
    }
    return false;
}
public void displayLosingMessage()
{
    int n = 0;
    String loseMessage = "YOU LOSE";
    for(int c = 5; c < 13; c++) {
        buttons[10][c].setLabel(loseMessage.substring(n, n+1));
        n++;
    }
}
public void displayWinningMessage()
{
    int n = 0;
    String winMessage = "YOU WIN";
    for(int c = 6; c < 13; c++) {
        buttons[10][c].setLabel(winMessage.substring(n, n+1));
        n++;
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
            marked = !marked;
            if(isWon())
                displayWinningMessage();
            if(marked == false)
                clicked = false;
        }
        else if(bombs.contains(this)) {
            for(MSButton bomb : bombs)
                bomb.clicked = true;
            displayLosingMessage();
        }
        else if(countBombs(r, c) > 0)
            setLabel("" + countBombs(r, c));
        else
            for(int i = -1; i <= 1; i++)
                for(int j = -1; j <= 1; j++)
                    if(isValid(r+i, c+j) && !buttons[r+i][c+j].isClicked())
                        buttons[r+i][c+j].mousePressed();
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
      if(r >= NUM_ROWS || r < 0)
        return false;
      else if(c >= NUM_COLS || c < 0)
        return false;
      return true;
    }
    public int countBombs(int row, int col)
    {
        int ct = 0;
        for(int i = -1; i <= 1; i++)
            for(int j = -1; j <= 1; j++)
                if((i == 0 && j == 0) == false)
                    if(isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
                        ct++;
        return ct;
    }
}



