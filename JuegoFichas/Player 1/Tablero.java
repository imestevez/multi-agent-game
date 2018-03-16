// Environment code for project player.mas2j

import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.util.*;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.Random;
import java.util.logging.Logger;

public class Tablero extends Environment {

    public static final int GSize = 10; // grid size
    public static final int BLUESTEAK  = 16; // steak code in grid model
	public static final int REDSTEAK  = 32; // steak code in grid model
	public static final int GREENSTEAK  = 64; // steak code in grid model
	public static final int BLACKSTEAK  = 128; // steak code in grid model
	public static final int ORANGESTEAK  = 256; // steak code in grid model
	public static final int MAGENTASTEAK  = 512; // steak code in grid model
	

    private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

    private TableroModel model;
    private TableroView  view;
    
	String label = "";
	int play = 0;
    /** Called before the MAS execution with the args informed in .mas2j */
    @Override
    public void init(String[] args) {
        model = new TableroModel();
        view  = new TableroView(model);
        model.setView(view);
        super.init(args);
		addPercept(Literal.parseLiteral("sizeof(" + (GSize - 1) + ")"));
    }

    @Override
    public boolean executeAction(String ag, Structure action) {
        logger.info(ag+" doing: "+ action);
        try {
             if (ag.equals("judge")) {
				 if (action.getFunctor().equals("put")) {
					 play = 0;
					 int x = (int)((NumberTerm)action.getTerm(0)).solve();
					 int y = (int)((NumberTerm)action.getTerm(1)).solve();
					 int c = (int)((NumberTerm)action.getTerm(2)).solve();
					 int steak = (int)((NumberTerm)action.getTerm(3)).solve();
					 if (steak <0) { 
							steak = -steak;
						 	play = 1;};
					 if (steak == 0) { label = "";} else
					 if (steak == 1) { label = "IP";} else
					 if (steak == 2) { label = "CT";} else
					 if (steak == 3) { label = "GS";} else
					 if (steak == 4) { label = "CO";} else {label = "";};
					 if (c < 0) { play = 2; model.put(x,y,-c,label,play);}
					 else { model.put(x,y,c,label,play);};
					 if (play==1|play==2) {logger.info("La casilla: ( "+x+", "+y+") tiene que ser pintada para el player"+play+".................................................");};
				 } else if(action.getFunctor().equals("exchange")){
					 int c1 = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x1 = (int)((NumberTerm)action.getTerm(1)).solve();
					 int x2 = (int)((NumberTerm)action.getTerm(2)).solve();
					 int c2 = (int)((NumberTerm)action.getTerm(3)).solve();
					 int y1 = (int)((NumberTerm)action.getTerm(4)).solve();
					 int y2 = (int)((NumberTerm)action.getTerm(5)).solve();
					 model.exchange(c1,x1,x2,c2,y1,y2);
				 } else if(action.getFunctor().equals("deleteSteak")){
					 int c = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x = (int)((NumberTerm)action.getTerm(1)).solve();
					 int y = (int)((NumberTerm)action.getTerm(2)).solve();
					 model.deleteSteak(c,x,y);
				 } 
			} else {
				logger.info("Recibido una peticion ilegal. "+ag+" no puede realizar la accion: "+ action);
				Literal ilegal = Literal.parseLiteral("accionIlegal(" + ag + ")");
			addPercept("judge",ilegal);}
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        updatePercepts();

        try {
            Thread.sleep(50);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }

    /** creates the agents perception based on the MarsModel */
    void updatePercepts() {
        Location r1Loc = model.getAgPos(0);
        Literal pos1 = Literal.parseLiteral("pos(r1," + r1Loc.x + "," + r1Loc.y + ")");
		addPercept(pos1);    
    }

    class TableroModel extends GridWorldModel {
        
        Random random = new Random(System.currentTimeMillis());
		
		String label = "";
		int play = 0;

        private TableroModel() {
            super(GSize, GSize, 2);
			//String label = label;
            // initial location of agents
            try {
                setAgPos(0, 0, 0);
            } catch (Exception e) {
                e.printStackTrace();
            }
			//set(4,GSize/2,GSize/2);
        }

		void put(int x, int y, int c, String steak, int player) throws Exception {
			if (isFreeOfObstacle(x,y)) {
				if (steak=="CT"|steak=="IP"|steak=="GS"|steak=="CO") {label = steak;} else { label= "";};
				play = player;
				set(c,x,y);
				addPercept( Literal.parseLiteral("steak(" + c + "," + x + "," + y + ")"));
				if (player ==1 | player==2) {
					removePercept(Literal.parseLiteral("player(1," + x + "," + y + ")"));
					removePercept(Literal.parseLiteral("player(2," + x + "," + y + ")"));
					addPercept( Literal.parseLiteral("player(" + player + "," + x + "," + y + ")"));
				};
			} 
        }
		
		void exchange(int c1, int x1, int x2, int c2, int y1, int y2) throws Exception {
			remove(c1,new Location(x1,y1));
			removePercept(Literal.parseLiteral("steak("+ c1 +"," + x1 + "," + y1 + ")"));
			remove(c2,new Location(x2,y2));
			removePercept(Literal.parseLiteral("steak(" + c2 + "," + x2 + "," + y2 + ")"));

			set(c2,x1,y1);
			addPercept(Literal.parseLiteral("steak("+ c2 +"," + x1 + "," + y1 + ")"));
			set(c1,x2,y2);
			addPercept(Literal.parseLiteral("steak(" + c1 + "," + x2 + "," + y2 + ")"));
		}
		
		void deleteSteak(int c,int x, int y) throws Exception {
			remove(c,new Location(x,y));
			removePercept(Literal.parseLiteral("steak("+ c +"," + x + "," + y + ")"));
		}
		
		//}
        
    }
    
    class TableroView extends GridWorldView {
		
        public TableroView(TableroModel model) {
            super(model, "Tablero", 400);
            defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
            setVisible(true);
			String label = model.label;
			int play = model.play;
            //repaint();
        }

        /** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int object) {
            switch (object) {
                case Tablero.BLUESTEAK: drawSTEAK(g, x, y, Color.blue, label, play);  break;
				case Tablero.REDSTEAK: drawSTEAK(g, x, y, Color.red, label, play);  break;
				case Tablero.GREENSTEAK: drawSTEAK(g, x, y, Color.green, label, play);  break;
				case Tablero.BLACKSTEAK: drawSTEAK(g, x, y, Color.lightGray, label, play);  break;
				case Tablero.ORANGESTEAK: drawSTEAK(g, x, y, Color.orange, label, play);  break;
				case Tablero.MAGENTASTEAK: drawSTEAK(g, x, y, Color.magenta, label, play);  break;
            }
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            //String label = "R"+(id+1);
            c = Color.pink;
            //super.drawAgent(g, x, y, c, -1);
			//drawGarb(g, x, y);
		}
		
		public void drawSTEAK(Graphics g, int x, int y, Color c, String label, int play) {
			if (play==1) {drawTRABA1(g,x,y);};
			if (play==2) {drawTRABA2(g,x,y);};
			g.setColor(c);
			g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
			g.setColor(Color.black);
			drawString(g,x,y,defaultFont,label);
		}

        public void drawTRABA1(Graphics g, int x, int y) {
			Color color = new Color(20,210,210);	
			g.setColor(color);
			g.fillRect(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW, cellSizeH);
			//super.drawEmpty(g,x,y);
		   //super.drawObstacle(g, x, y);
           	//g.setColor(Color.black);
            //drawString(g, x, y, defaultFont, label);
        }

        public void drawTRABA2(Graphics g, int x, int y) {
			Color color = new Color(210,210,20);	
			g.setColor(color);
			g.fillRect(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW, cellSizeH);
			//super.drawEmpty(g,x,y);
		   //super.drawObstacle(g, x, y);
        }

    }    

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        super.stop();
    }
}

