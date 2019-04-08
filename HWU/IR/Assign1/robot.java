
import java.applet.Applet;

import java.awt.*;

import java.awt.event.*;

import com.sun.j3d.utils.applet.MainFrame;

import com.sun.j3d.utils.picking.*;

import com.sun.j3d.utils.picking.behaviors.*;

import com.sun.j3d.utils.geometry.*;

import com.sun.j3d.utils.image.TextureLoader;

import com.sun.j3d.utils.universe.*;

import com.sun.j3d.utils.behaviors.mouse.*;

import javax.media.j3d.*;

import javax.vecmath.*;

import javax.media.j3d.GeometryStripArray.*;

import java.awt.event.*;

import java.awt.image.*;

import javax.swing.*;

import javax.swing.event.*;


/********************* Note from Nick Taylor **********************
Note that the main class and program file must have the same name
E.g. main class = "robot"; program file = "robot.java"
The constructor method for the class must also have the same name
Compile with command "javac robot.java"; this creates "robot.class"
Execute "robot.class" with command "java robot"
*/

// Main class

public class robot extends Applet implements

							MouseMotionListener,

						  	ActionListener,

						  	ChangeListener,

						  	ItemListener {



    JPanel ipanel, apanel, cpanel, speedpanel, t1panel, t2panel, t3panel, t4panel, 

	posxpanel, posypanel, poszpanel, apprpanel, tcpvpanel, rbpanel;

    JPanel imapanel, imalabpanel, tcopanel, tcolabpanel, tcoerrorpanel, icopanel, icolabpanel, tcoippanel;

    JPanel pxspanel, pyspanel, pzspanel, aaspanel;

    JPanel rsizepanel, rsizelabpanel, rd1panel, rd2panel, rd3panel, rd4panel;



    JPanel vdpanel, vdsubpanel, vdlabpanel;

    javax.swing.Box vdt1panel,vdt2panel, vdt3panel, vdt4panel;

    javax.swing.Box settingpanel;

    JTabbedPane tpane;

    JSlider theta1Slider, theta2Slider, theta3Slider, theta4Slider;

    JSlider pxSlider, pySlider, pzSlider, aaSlider;

    JSlider rd1Slider, rd2Slider, rd3Slider, rd4Slider;

    JTextField posxTextField, posyTextField, poszTextField, apprTextField, tcpvTextField;

    JCheckBox illegalpathCheckBox, showtargetCheckBox, reachunderCheckBox;

    JProgressBar t1velocitybar, t2velocitybar, t3velocitybar, t4velocitybar;

    JLabel theta1Label, theta2Label, theta3Label, theta4Label,posxlabel, posylabel, poszlabel, apprlabel, tcpvlabel;

    JLabel imalabel, imalabel2, tcolabel, tcoerrorlabel, icolabel;

    JLabel theta1velocityLabel, theta2velocityLabel, theta3velocityLabel, theta4velocityLabel, imavelocitylabel;

    JLabel pxslabel, pyslabel, pzslabel, aaslabel, rsizelabel;

    JLabel rd1label, rd2label, rd3label, rd4label;

    JLabel vdlabel, t1velocitylabel, t2velocitylabel, t3velocitylabel, t4velocitylabel, 

	t1ivlabel, t2ivlabel, t3ivlabel, t4ivlabel,

	t1aslabel, t2aslabel, t3aslabel, t4aslabel;



    JButton reposButton;

    Canvas3D canvas;



    java.text.DecimalFormat dp2 = new java.text.DecimalFormat("#,##0.0");



    Font littleFont = new Font("sansserif", 1, 9);

    String initavspeed = "Av.Speed = N/A             ";

    String initinvel   = "Velocity = " + dp2.format(0.0f) + "\u2070/s             ";

    String invelpre = "Velocity = ", invelpost = " \u2070/s";

    String avspeedpre = "Av.Speed = ", avspeedpost = " \u2070/s";



    int stepspersecond = 15; //animation steps per second

    int velocityBarMax = 80; //maximum value of velocity display bars



    Color velocityBarPosColor = Color.red;

    Color velocityBarNegColor = Color.blue;



    boolean showTarget = false, reachUnder = false, overridePref = false;



    // BasicUniverse universe;



    BoundingSphere bounds;



    static Vector3d vZeros = new Vector3d(0.0, 0.0, 0.0);



    //transform groups



    //target sphere

    TransformGroup txTG;

    //robot arm

    TransformGroup robotBaseTG;

    TransformGroup robotUprightTG;

    TransformGroup robotD2TG;

    TransformGroup robotD3TG;

    TransformGroup robotD4TG;





    //lengths of robot arm sections

    float base = 1f,

	d1 = 5f,

	d2 = 6f,

	d3 = 4f,

	d4 = 2f;





    //angles of robot arm joints

    float theta1 = 0.0f,

	theta2 = (float) Math.toRadians(45),//0.0f,

	theta3 = (float) Math.toRadians(40),//0.0f,

	theta4 = (float) Math.toRadians(40);



    //TCP 'live' actual position

    //**************************



    //TCP position

    float px = -3.5f,

	py = -3.5f,

	pz = 1.5f;

    //TCP approach angle

    float alpha = 0.0f;



    //TCP 'next' target position

    //**************************



    //TCP target position

    float targetpx = px,

	targetpy = py,

	targetpz = pz;

    //TCP target approach angle

    float targetalpha = 0.0f;



    //TCP 'last' start position

    //**************************



    //TCP start position

    float startpx = 0.0f,

	startpy = 0.0f,

	startpz = 0.0f;

    //TCP target approach angle

    float startalpha = 0.0f;



    //************ GUI callback methods **************

    //************************************************





    //slider changed

    //**************

    public void stateChanged( ChangeEvent e )

    {

	JSlider source = (JSlider) e.getSource();


	if( source.getValueIsAdjusting() ){


	    if( source == theta1Slider ){

		theta1 = (float) Math.toRadians(source.getValue());

		positionArm();

	    }else if( source == theta2Slider ){

		theta2 = (float) Math.toRadians(source.getValue());

		positionArm();

	    }else if( source == theta3Slider ){

		theta3 = (float) Math.toRadians(source.getValue());

		positionArm();

	    }else if( source == theta4Slider ){

		theta4 = (float) Math.toRadians(source.getValue());

		positionArm();

	    }else if( source == pxSlider ){

/*********************** Note from Nick Taylor ********************
This is where the x co-ordinate for the TCP is supplied by the user
*/

		px = ((float) (source.getValue())) / 1000;

		calcThetas();

		positionArm();

		positionThetaSliders();

		updateCoOrdTextFields();

	    }else if( source == pySlider ){

/*********************** Note from Nick Taylor ********************
This is where the y co-ordinate for the TCP is supplied by the user
*/

		py = ((float) (source.getValue())) / 1000;

		calcThetas();

		positionArm();

		positionThetaSliders();

		updateCoOrdTextFields();

	    }else if( source == pzSlider ){

/*********************** Note from Nick Taylor ********************
This is where the z co-ordinate for the TCP is supplied by the user
*/

		pz = ((float) (source.getValue())) / 1000;

		calcThetas();

		positionArm();

		positionThetaSliders();

		updateCoOrdTextFields();

	    }else if( source == aaSlider ){

/*********************** Note from Nick Taylor ******************
This is where the orientation for the TCP is supplied by the user
*/

		alpha = (float) Math.toRadians(source.getValue());

		calcThetas();

		positionArm();

		positionThetaSliders();

		updateCoOrdTextFields();

	    }else if( source == rd1Slider ){

		d1 = (float) source.getValue();

		calcThetas();

		positionArm();

		positionThetaSliders();

	    }else if( source == rd2Slider ){

		d2 = (float) source.getValue();

		calcThetas();

		positionArm();

		positionThetaSliders();

	    }else if( source == rd3Slider ){

		d3 = (float) source.getValue();

		calcThetas();

		positionArm();

		positionThetaSliders();

	    }else if( source == rd4Slider ){

		d4 = (float) source.getValue();

		calcThetas();

		positionArm();

		positionThetaSliders();

	    }

	}

    }

    

    public void mouseDragged(MouseEvent e) {}

        

    public void mouseMoved(MouseEvent e) {}

    

    // action listener for buttons

    //****************************

    public void actionPerformed(ActionEvent e)

    {

	targetpx = Float.parseFloat(posxTextField.getText());

	targetpy = Float.parseFloat(posyTextField.getText());

	targetpz = Float.parseFloat(poszTextField.getText());

	targetalpha = (float) Math.toRadians(Float.parseFloat(apprTextField.getText()));

	float tcpvelocity = Float.parseFloat(tcpvTextField.getText());



	startpx = px;

	startpy = py;

	startpz = pz;

	startalpha = alpha;



	int steps = 50;



	if( showTarget ){

	    showTarget();

	}



	overridePref = false;



	if( pathClearTest(steps) == false ) {

	    //illegal path - flag user

	    tcoerrorlabel.setForeground(Color.red);

	    tcoerrorlabel.setText("Illegal Path Set!");

	    tcoerrorlabel.repaint(); //**************************

	    if( illegalpathCheckBox.isSelected() == true ){

		//illegal path but allowed - move

		moveRobot(tcpvelocity);

	    }

	}else{

	    //legal path - move

	    tcoerrorlabel.setForeground(Color.green);

	    tcoerrorlabel.setText("           Valid Path            ");

	    tcoerrorlabel.repaint();

	    moveRobot(tcpvelocity);

	}

	overridePref = false;



    }



    // listener for checkboxes

    public void itemStateChanged( ItemEvent e )

    {

	JCheckBox source = (JCheckBox) e.getSource();



	if( source == showtargetCheckBox ){

	    if( source.isSelected() ){

		showTarget = true;

		showTarget();

	    }else{

		showTarget = false;

		hideTarget();

	    }

	}else if( source == reachunderCheckBox ){

	    if( source.isSelected() ){

		reachUnder = true;

	    }else{

		reachUnder = false;

	    }

	    calcThetas();

	    positionArm();

	}

    }



    //class constructor

    public robot()

    {

	// layout and pane

	setLayout(new BorderLayout());



	tpane = new JTabbedPane();	



	//immediate panel

	ipanel = new JPanel();

	ipanel.setLayout( new GridLayout(2, 0, 1, 1));



	//animation panel

	apanel = new JPanel();

	apanel.setLayout( new GridLayout(2, 0, 1, 1));



	//config panel

	cpanel = new JPanel();

	cpanel.setLayout( new GridLayout(3, 0, 1, 1));



	//immediate joint angle panel

	//***************************



	imapanel = new JPanel();

	imapanel.setLayout( new GridLayout(5, 0) );

	imapanel.setBorder(BorderFactory.createLineBorder(Color.black));



	imalabpanel = new JPanel();

	imalabel = new JLabel("        Immediate - Angles           ");

	imalabpanel.add( imalabel );

	imavelocitylabel = new JLabel("Velocity");

	imalabpanel.add( imavelocitylabel );

	imapanel.add( imalabpanel );



	t1panel = new JPanel();



	// slider for theta1

	theta1Label = new JLabel("Theta1");

	t1panel.add( theta1Label );



	int SLIDERMIN=-180;

	int SLIDERMAX=180;

	int SLIDERINIT=0;

	theta1Slider = new JSlider( JSlider.HORIZONTAL,

				    SLIDERMIN,

				    SLIDERMAX,

				    (int) Math.toDegrees(theta1) );

	theta1Slider.setMajorTickSpacing( 90 );

	theta1Slider.setMinorTickSpacing( 15 );

	theta1Slider.setPaintTicks( true );

	theta1Slider.setPaintLabels( true );

	theta1Slider.addChangeListener( this );

	t1panel.add( theta1Slider );



	//velocity

 	theta1velocityLabel = new JLabel("  0.0 d/s");

 	t1panel.add( theta1velocityLabel );



	imapanel.add( t1panel );



	t2panel = new JPanel();



	// slider for theta2

	theta2Label = new JLabel("Theta2");

	t2panel.add( theta2Label );



	theta2Slider = new JSlider( JSlider.HORIZONTAL,

				    SLIDERMIN,

				    SLIDERMAX,

				    (int) Math.toDegrees(theta2) );

	theta2Slider.setMajorTickSpacing( 90 );

	theta2Slider.setMinorTickSpacing( 15 );

	theta2Slider.setPaintTicks( true );

	theta2Slider.setPaintLabels( true );

	theta2Slider.addChangeListener( this );

	t2panel.add( theta2Slider );



	//velocity

	theta2velocityLabel = new JLabel("  0.0 d/s");

	t2panel.add( theta2velocityLabel );



	imapanel.add( t2panel );



	t3panel = new JPanel();



	// slider for theta3

	theta3Label = new JLabel("Theta3");

	t3panel.add( theta3Label );



	theta3Slider = new JSlider( JSlider.HORIZONTAL,

				    SLIDERMIN,

				    SLIDERMAX,

				    (int) Math.toDegrees(theta3) );

	theta3Slider.setMajorTickSpacing( 90 );

	theta3Slider.setMinorTickSpacing( 15 );

	theta3Slider.setPaintTicks( true );

	theta3Slider.setPaintLabels( true );

	theta3Slider.addChangeListener( this );

	t3panel.add( theta3Slider );



	//velocity

	theta3velocityLabel = new JLabel("  0.0 d/s");

	t3panel.add( theta3velocityLabel );



	imapanel.add( t3panel );



	t4panel = new JPanel();



	// slider for theta4

	theta4Label = new JLabel("Theta4");

	t4panel.add( theta4Label );



	theta4Slider = new JSlider( JSlider.HORIZONTAL,

				    SLIDERMIN,

				    SLIDERMAX,

				    (int) Math.toDegrees(theta4) );

	theta4Slider.setMajorTickSpacing( 90 );

	theta4Slider.setMinorTickSpacing( 15 );

	theta4Slider.setPaintTicks( true );

	theta4Slider.setPaintLabels( true );

	theta4Slider.addChangeListener( this );

	t4panel.add( theta4Slider );



	//velocity

	theta4velocityLabel = new JLabel("  0.0 d/s");

	t4panel.add( theta4velocityLabel );



	imapanel.add( t4panel );



	ipanel.add( imapanel );



	//target - co-ordinates panel

	//***************************



	tcopanel = new JPanel();

	tcopanel.setLayout( new GridLayout(0, 1) );

	tcopanel.setBorder(BorderFactory.createLineBorder(Color.black));



	tcolabpanel = new JPanel();

	tcolabel = new JLabel("Target - TCP Co-ordinates");

	tcolabpanel.add( tcolabel );

	tcopanel.add( tcolabpanel );



	//x position entry

	posxpanel = new JPanel();



	posxlabel = new JLabel("X position (m)");

	posxpanel.add( posxlabel );



	posxTextField = new JTextField(8);

	posxpanel.add( posxTextField );



	tcopanel.add( posxpanel );



	//y position entry

	posypanel = new JPanel();



	posylabel = new JLabel("Y position (m)");

	posypanel.add( posylabel );



	posyTextField = new JTextField(8);

	posypanel.add( posyTextField );



	tcopanel.add( posypanel );



	//z position entry

	poszpanel = new JPanel();



	poszlabel = new JLabel("Z position (m)");

	poszpanel.add( poszlabel );



	poszTextField = new JTextField(8);

	poszpanel.add( poszTextField );



	tcopanel.add( poszpanel );



	//approach angle entry

	apprpanel = new JPanel();



	apprlabel = new JLabel("Approach Angle (o)");

	apprpanel.add( apprlabel );



	apprTextField = new JTextField(8);

	apprpanel.add( apprTextField );



	tcopanel.add( apprpanel );



	//TCP velocity entry

	tcpvpanel = new JPanel();



	tcpvlabel = new JLabel("TCP Velocity (m/s)");

	tcpvpanel.add( tcpvlabel );



	tcpvTextField = new JTextField(8);

	tcpvTextField.setText("1");

	tcpvpanel.add( tcpvTextField );



	tcopanel.add( tcpvpanel );



	//error illegal path label

	tcoerrorpanel = new JPanel();

	tcoerrorlabel = new JLabel("                             ");



	tcoerrorpanel.add( tcoerrorlabel );

	tcopanel.add( tcoerrorpanel );



	//allow illegal path checkbox

	tcoippanel = new JPanel();

	illegalpathCheckBox = new JCheckBox("Allow Illegal Path", false);

	tcoippanel.add( illegalpathCheckBox );

	tcopanel.add( tcoippanel );



	// button for move

	reposButton = new JButton( "RePosition" );

	reposButton.addActionListener( this );

	tcopanel.add( reposButton );



	apanel.add( tcopanel );



	//immediate co-ordinate panel

	//***************************



	icopanel = new JPanel();

	icopanel.setLayout( new GridLayout(0, 1) );

	icopanel.setBorder(BorderFactory.createLineBorder(Color.black));





	icolabpanel = new JPanel();

	icolabel = new JLabel("Immediate - TCP Co-ordinates");

	icolabpanel.add( icolabel );

	icopanel.add( icolabpanel );



	int pSLIDERMIN=-10000;

	int pSLIDERMAX=10000;

	int pMINORTICKSPACE = 1000;

	int pMAJORTICKSPACE = 5000;



	// slider for co-ord pos x

	pxspanel = new JPanel();



	pxslabel = new JLabel("X Co-Ord (mm)");

	pxspanel.add( pxslabel );



	pxSlider = new JSlider( JSlider.HORIZONTAL,

				    pSLIDERMIN,

				    pSLIDERMAX,

				    (int) px);

	pxSlider.setMajorTickSpacing( pMAJORTICKSPACE );

	pxSlider.setMinorTickSpacing( pMINORTICKSPACE );

	pxSlider.setPaintTicks( true );

	pxSlider.setPaintLabels( true );

	pxSlider.addChangeListener( this );

	pxspanel.add( pxSlider );



	icopanel.add( pxspanel );



	// slider for co-ord pos y

	pyspanel = new JPanel();



	pyslabel = new JLabel("Y Co-Ord (mm)");

	pyspanel.add( pyslabel );



	pySlider = new JSlider( JSlider.HORIZONTAL,

				    pSLIDERMIN,

				    pSLIDERMAX,

				    (int) py);

	pySlider.setMajorTickSpacing( pMAJORTICKSPACE );

	pySlider.setMinorTickSpacing( pMINORTICKSPACE );

	pySlider.setPaintTicks( true );

	pySlider.setPaintLabels( true );

	pySlider.addChangeListener( this );

	pyspanel.add( pySlider );



	icopanel.add( pyspanel );



	// slider for co-ord pos z

	pzspanel = new JPanel();



	pzslabel = new JLabel("Z Co-Ord (mm)");

	pzspanel.add( pzslabel );



	pzSlider = new JSlider( JSlider.HORIZONTAL,

				    pSLIDERMIN,

				    pSLIDERMAX,

				    (int) pz);

	pzSlider.setMajorTickSpacing( pMAJORTICKSPACE );

	pzSlider.setMinorTickSpacing( pMINORTICKSPACE );

	pzSlider.setPaintTicks( true );

	pzSlider.setPaintLabels( true );

	pzSlider.addChangeListener( this );

	pzspanel.add( pzSlider );



	icopanel.add( pzspanel );



	// slider for approach angle

	aaspanel = new JPanel();



	aaslabel = new JLabel("Approach Angle");

	aaspanel.add( aaslabel );



	aaSlider = new JSlider( JSlider.HORIZONTAL,

				    -180,

				    180,

				    (int) alpha);

	aaSlider.setMajorTickSpacing( 90 );

	aaSlider.setMinorTickSpacing( 15 );

	aaSlider.setPaintTicks( true );

	aaSlider.setPaintLabels( true );

	aaSlider.addChangeListener( this );

	aaspanel.add( aaSlider );



	icopanel.add( aaspanel );



	ipanel.add( icopanel );



	//velocity display panel

	//**********************



	vdpanel = new JPanel();

	vdpanel.setLayout( new BorderLayout() );

	vdpanel.setBorder(BorderFactory.createLineBorder(Color.black));



	vdsubpanel = new JPanel();

	vdsubpanel.setLayout( new GridLayout(0, 2, 0, 6) );



	vdlabpanel = new JPanel();

	vdlabel = new JLabel("Velocity");

	vdlabpanel.add( vdlabel );

	vdpanel.add( BorderLayout.NORTH, vdlabpanel );



	//theta1 bar

	vdt1panel = new javax.swing.Box( javax.swing.BoxLayout.Y_AXIS );

	//	vdt1panel.setLayout( BoxLayout(vdt1panel, BoxLayout.Y_AXIS ));



	//label

	t1velocitylabel = new JLabel("Theta1");

	vdt1panel.add(t1velocitylabel);



	//bar

	t1velocitybar = new JProgressBar(JProgressBar.VERTICAL, 0, velocityBarMax);

	t1velocitybar.setValue(0);

	t1velocitybar.setString("theta1");

	t1velocitybar.setStringPainted(true);

	t1velocitybar.setForeground(Color.blue);

	vdt1panel.add(t1velocitybar);



	//instantaneous velo

	t1ivlabel = new JLabel(initinvel);

	t1ivlabel.setFont( littleFont );

	vdt1panel.add(t1ivlabel);



	//average speed

	t1aslabel = new JLabel(initavspeed);

	t1aslabel.setFont( littleFont );

	vdt1panel.add(t1aslabel);



	vdsubpanel.add( vdt1panel );



	//theta2 bar

	//	vdt2panel = new JPanel();

	vdt2panel = new javax.swing.Box( javax.swing.BoxLayout.Y_AXIS );



	//label

	t2velocitylabel = new JLabel("Theta2");

	vdt2panel.add(t2velocitylabel);



	//bar

	t2velocitybar = new JProgressBar(JProgressBar.VERTICAL, 0, velocityBarMax);

	t2velocitybar.setValue(0);

	t2velocitybar.setString("theta2");

	t2velocitybar.setStringPainted(true);

	t2velocitybar.setForeground(Color.blue);

	vdt2panel.add(t2velocitybar);



	//instantaneous velo

	t2ivlabel = new JLabel(initinvel);

	t2ivlabel.setFont( littleFont );

	vdt2panel.add(t2ivlabel);



	//average speed

	t2aslabel = new JLabel(initavspeed);

	t2aslabel.setFont( littleFont );

	vdt2panel.add(t2aslabel);



	vdsubpanel.add( vdt2panel );



	//theta3 bar

	//	vdt3panel = new JPanel();

	vdt3panel = new javax.swing.Box( javax.swing.BoxLayout.Y_AXIS );



	//label

	t3velocitylabel = new JLabel("Theta3");

	vdt3panel.add(t3velocitylabel);



	//bar

	t3velocitybar = new JProgressBar(JProgressBar.VERTICAL, 0, velocityBarMax);

	t3velocitybar.setValue(0);

	t3velocitybar.setString("theta3");

	t3velocitybar.setStringPainted(true);

	t3velocitybar.setForeground(Color.blue);

	vdt3panel.add(t3velocitybar);



	//instantaneous velo

	t3ivlabel = new JLabel(initinvel);

	t3ivlabel.setFont( littleFont );

	vdt3panel.add(t3ivlabel);



	//average speed

	t3aslabel = new JLabel(initavspeed);

	t3aslabel.setFont( littleFont );

	vdt3panel.add(t3aslabel);



	vdsubpanel.add( vdt3panel );



	//theta4 bar

	//	vdt4panel = new JPanel();

	vdt4panel = new javax.swing.Box( javax.swing.BoxLayout.Y_AXIS );



	//label

	t4velocitylabel = new JLabel("Theta4");

	vdt4panel.add(t4velocitylabel);



	//bar

	t4velocitybar = new JProgressBar(JProgressBar.VERTICAL, 0, velocityBarMax);

	t4velocitybar.setValue(0);

	t4velocitybar.setString("theta4");

	t4velocitybar.setStringPainted(true);

	t4velocitybar.setForeground(Color.blue);

	vdt4panel.add(t4velocitybar);



	//instantaneous velocity

	t4ivlabel = new JLabel(initinvel);

	t4ivlabel.setFont( littleFont );

	vdt4panel.add(t4ivlabel);



	//average speed

	t4aslabel = new JLabel(initavspeed);

	t4aslabel.setFont( littleFont );

	vdt4panel.add(t4aslabel);



	vdsubpanel.add( vdt4panel );



	vdpanel.add( BorderLayout.CENTER, vdsubpanel);



	apanel.add( vdpanel );



	//robot section length (d) panel

	//***************************



	rsizepanel = new JPanel();

	rsizepanel.setLayout( new GridLayout(0, 1) );

	rsizepanel.setBorder(BorderFactory.createLineBorder(Color.black));





	rsizelabpanel = new JPanel();

	rsizelabel = new JLabel("Config - Robot Arm Lengths");

	rsizelabpanel.add( rsizelabel );

	rsizepanel.add( rsizelabpanel );



	int dSLIDERMIN=0;

	int dSLIDERMAX=10;

	int dMINORTICKSPACE = 1;

	int dMAJORTICKSPACE = 5;



	// slider for d1

	rd1panel = new JPanel();



	rd1label = new JLabel("d1 (m)");

	rd1panel.add( rd1label );



	rd1Slider = new JSlider( JSlider.HORIZONTAL,

				    dSLIDERMIN,

				    dSLIDERMAX,

				    (int) d1);

	rd1Slider.setMajorTickSpacing( dMAJORTICKSPACE );

	rd1Slider.setMinorTickSpacing( dMINORTICKSPACE );

	rd1Slider.setPaintTicks( true );

	rd1Slider.setPaintLabels( true );

	rd1Slider.addChangeListener( this );

	rd1panel.add( rd1Slider );



	rsizepanel.add( rd1panel );



	// slider for d2

	rd2panel = new JPanel();



	rd2label = new JLabel("d2 (m)");

	rd2panel.add( rd2label );



	rd2Slider = new JSlider( JSlider.HORIZONTAL,

				    dSLIDERMIN,

				    dSLIDERMAX,

				    (int) d2);

	rd2Slider.setMajorTickSpacing( dMAJORTICKSPACE );

	rd2Slider.setMinorTickSpacing( dMINORTICKSPACE );

	rd2Slider.setPaintTicks( true );

	rd2Slider.setPaintLabels( true );

	rd2Slider.addChangeListener( this );

	rd2panel.add( rd2Slider );



	rsizepanel.add( rd2panel );



	// slider for d3

	rd3panel = new JPanel();



	rd3label = new JLabel("d3 (m)");

	rd3panel.add( rd3label );



	rd3Slider = new JSlider( JSlider.HORIZONTAL,

				    dSLIDERMIN,

				    dSLIDERMAX,

				    (int) d3);

	rd3Slider.setMajorTickSpacing( dMAJORTICKSPACE );

	rd3Slider.setMinorTickSpacing( dMINORTICKSPACE );

	rd3Slider.setPaintTicks( true );

	rd3Slider.setPaintLabels( true );

	rd3Slider.addChangeListener( this );

	rd3panel.add( rd3Slider );



	rsizepanel.add( rd3panel );



	// slider for d4

	rd4panel = new JPanel();



	rd4label = new JLabel("d4 (m)");

	rd4panel.add( rd4label );



	rd4Slider = new JSlider( JSlider.HORIZONTAL,

				    dSLIDERMIN,

				    dSLIDERMAX,

				    (int) d4);

	rd4Slider.setMajorTickSpacing( dMAJORTICKSPACE );

	rd4Slider.setMinorTickSpacing( dMINORTICKSPACE );

	rd4Slider.setPaintTicks( true );

	rd4Slider.setPaintLabels( true );

	rd4Slider.addChangeListener( this );

	rd4panel.add( rd4Slider );



	rsizepanel.add( rd4panel );



	cpanel.add( rsizepanel );



	//settings option panel

	settingpanel = new javax.swing.Box( javax.swing.BoxLayout.Y_AXIS );



	//show target option

	showtargetCheckBox = new JCheckBox("Show Target Sphere", false);

	showtargetCheckBox.addItemListener( this );

	settingpanel.add( showtargetCheckBox );



	//reach under option

	reachunderCheckBox = new JCheckBox("Reach Under", false);

	reachunderCheckBox.addItemListener( this );

	settingpanel.add( reachunderCheckBox );



	cpanel.add( settingpanel );



	//add panels to tabbed pane

	tpane.add("Immediate", ipanel);

	tpane.add("Animate", apanel);

	tpane.add("Config", cpanel);



	//add graphics canvas

	//*******************



	GraphicsConfiguration graphicsConfig = SimpleUniverse.getPreferredConfiguration();

	canvas = new Canvas3D( graphicsConfig );

	add("Center",canvas);

// Viewplatform fix by Mohamad Alissa
ViewingPlatform viewingPlatform = new ViewingPlatform();
viewingPlatform.getViewPlatform().setActivationRadius(300f);
    TransformGroup viewTransform = viewingPlatform.getViewPlatformTransform();
    Transform3D t3d = new Transform3D();
    t3d.lookAt(new Point3d(0,0,40), new Point3d(0,0,0), new Vector3d(0,1,0));
    t3d.invert();
    viewTransform.setTransform(t3d);
    Viewer viewer = new Viewer(canvas);
    View view = viewer.getView();
    view.setBackClipDistance(300);
    SimpleUniverse universe = new SimpleUniverse(viewingPlatform, viewer);


	// universe = new BasicUniverse(canvas, 50.0f);



	BranchGroup scene = createSceneGraph();

	universe.addBranchGraph(scene);



	add( BorderLayout.WEST, tpane );

	//	add( BorderLayout.WEST, panel );



	//initialise values and positions

	//*******************************



	calcThetas();

	updateCoOrdTextFields();

	positionThetaSliders();

	positionCoOrdSliders();

	positionArm();



	if( showTarget ) showTarget();

	



    }



    /**

     * Method to return a branchgroup containing the scene.

     */

    public BranchGroup createSceneGraph() {



	BranchGroup objRoot = new BranchGroup();



	bounds = new BoundingSphere(new Point3d(0.0,0.0,0.0),150.0);



	//***************************************************************************

	//LIGHTING

	//***************************************************************************



	// set directional light and add to BranchGroup

	DirectionalLight dirLight = new DirectionalLight();

	dirLight.setCapability(Light.ALLOW_STATE_WRITE);

	dirLight.setColor( new Color3f( 0.3f, 0.3f, 0.3f ) );

	dirLight.setDirection( new Vector3f( -1.0f, -16.0f, -16.0f ) );

	dirLight.setInfluencingBounds( bounds );

	objRoot.addChild( dirLight );



	// set ambient light and add to BranchGroup

	AmbientLight ambLight = new AmbientLight();

	ambLight.setCapability(Light.ALLOW_STATE_WRITE);

	ambLight.setColor( new Color3f( 0.55f, 0.55f, 0.55f ) );

	ambLight.setInfluencingBounds(bounds);

	objRoot.addChild( ambLight );



	// set point light and add to BranchGroup

	PointLight pl = new PointLight( new Color3f(10.0F,10.0F,5.0F), //colour

					new Point3f(-0.1F,-10.0F,5.0F), //pos

					new Point3f(0.1F,0.1F,0.1F) //attenuation

					);

	pl.setInfluencingBounds(bounds);

	objRoot.addChild(pl); 



	//***************************************************************************

	//ROOT TRANSFORM

	//***************************************************************************



	//Create base transform group, set capabilities

	TransformGroup objTrans = new TransformGroup();

	TransformGroup objMouseTrans = new TransformGroup();

	objMouseTrans.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);

	objMouseTrans.setCapability( TransformGroup.ALLOW_TRANSFORM_READ );

	objMouseTrans.setCapability(TransformGroup.ENABLE_PICK_REPORTING);

	objRoot.addChild(objMouseTrans);

	objMouseTrans.addChild(

			       xGroup('x', Math.PI/7, vZeros, new Vector3d(0.0, 0.0, 0.0),

				      xGroup('y', Math.PI, vZeros, new Vector3d(0.0, 0.0, 0.0),

					     objTrans

					     )

				      )

			       );







	//***************************************************************************

	// BACKGROUND

	//***************************************************************************





	Background bg = new Background(new Color3f(0.4f, 0.4f, 1.0f));

	bg.setApplicationBounds(bounds);

	BranchGroup bgGeomBranch = new BranchGroup();

	Sphere bgSphere = new Sphere(60.0f, Sphere.GENERATE_NORMALS_INWARD, 20);

	bgGeomBranch.addChild(bgSphere);

	bg.setGeometry(bgGeomBranch);

	objTrans.addChild(bg);



	//************* Appearances ****************

	//******************************************



	Appearance app1 = new Appearance();

	{

	    Material m = new Material();

	    m.setShininess(100.0f);	  

	    m.setSpecularColor(0.9f, 0.1f, 0.1f);

	    m.setDiffuseColor(0.9f, 0.1f, 0.2f);

	    m.setAmbientColor(0.9f, 0.0f, 0.0f);

	    m.setLightingEnable(true);

	    app1.setMaterial(m);

	}



	Appearance app2 = new Appearance();

	{

	    Material m = new Material();

	    m.setShininess(100.0f);	  

	    m.setSpecularColor(0.1f, 0.1f, 0.9f);

	    m.setDiffuseColor(0.1f, 0.1f, 0.9f);

	    m.setAmbientColor(0.1f, 0.0f, 0.9f);

	    m.setLightingEnable(true);

	    app2.setMaterial(m);

	}



	Appearance app3 = new Appearance();

	{

	    Material m = new Material();

	    m.setSpecularColor(0.2f, 0.8f, 0.2f);

	    m.setDiffuseColor(0.1f, 0.5f, 0.1f);

	    m.setAmbientColor(0.1f, 0.5f, 0.1f);

	    m.setShininess( 25.0f );

	    app3.setMaterial( m );

	}



	//draw axes

	{

	    float dia = 0.05f;

	    float length = 30;

	    Appearance axapp = app1;

	    {

		TransformGroup axTG = tGroup('z', 0.0f, vZeros, new Vector3d(0.0, (length/2), 0.0));

		Cylinder c = new Cylinder(dia, length, axapp);

		axTG.addChild(c);

		objTrans.addChild(axTG);

	    }

	    {

		TransformGroup axTG = tGroup('z', Math.toRadians(90), vZeros, new Vector3d(0.0, 0.1, 0.0));

		Cylinder c = new Cylinder(dia, length, axapp);

		axTG.addChild(c);

		objTrans.addChild(axTG);

	    }

	    {

		TransformGroup axTG = tGroup('x', Math.toRadians(90), vZeros, new Vector3d(0.0, 0.1, 0.0));

		Cylinder c = new Cylinder(dia, length, axapp);

		axTG.addChild(c);

		objTrans.addChild(axTG);

	    }

	}



	//draw target ball

	{

		txTG = tGroup('x', 0.0f, vZeros, new Vector3d(vZeros));

		Sphere s = new Sphere(0.2f, app3);

		txTG.addChild(s);

		objTrans.addChild(txTG);

	}



	//***************************************************************************

	//                                         ROBOT

	//***************************************************************************



	{ //base

	    float length = base;//height of base

	    float dia = 4;

	    Appearance a = app1;

	    //    robotBaseT3D.setTranslation(new Vector3d(0.0, (length/2), 0.0));

	    robotBaseTG = tGroup('z', 0.0f, vZeros, new Vector3d(0.0, (length/2), 0.0));

	    Cylinder c = new Cylinder(dia, length, a);

	    robotBaseTG.addChild(c);

	}



	{ //Upright

	    float length = d1/2;//height

	    Appearance a = app2;



	    robotUprightTG = tGroup('y', theta1, vZeros, vZeros);//new TransformGroup();



	    TransformGroup rectTG = tGroup('z', 0.0f, vZeros, new Vector3d(1.0, (length), 0.0));

	    com.sun.j3d.utils.geometry.Box b = new com.sun.j3d.utils.geometry.Box(2.0f, length, 1.0f, a);

	    rectTG.addChild(b);



	    robotUprightTG.addChild(rectTG);

	}



	{ //d2 arm

	    float length = d2/2;//

	    float dia = 1;		

	    float angle = (float) (Math.PI / 2) - theta2;

	    Appearance a = app2;



	    robotD2TG = tGroup('z', angle, vZeros, new Vector3d(0.0, d1, 0.0));



	    TransformGroup rectTG = tGroup('z', 0.0f, vZeros, new Vector3d(0.0, (length), 0.0));

	    com.sun.j3d.utils.geometry.Box b = new com.sun.j3d.utils.geometry.Box(0.6f, (length), 0.8f, a);

	    rectTG.addChild(b);



	    TransformGroup pivotTG = tGroup('x', Math.toRadians(90), vZeros, new Vector3d(0.0, 0.0, 0.0));

	    Cylinder c = new Cylinder(1.6f, 2.2f, app1);

	    pivotTG.addChild(c);



	    robotD2TG.addChild(rectTG);

	    robotD2TG.addChild(pivotTG);

	}



	{ //d3 arm

	    float length = d3/2;//

	    float dia = 1;		

	    float angle = (float) Math.toRadians(40);

	    Appearance a = app2;



	    robotD3TG = tGroup('z', theta3, vZeros, new Vector3d(0.0, d2, 0.0));



	    TransformGroup rectTG = tGroup('z', 0.0f, vZeros, new Vector3d(0.0, (length), 0.0));

	    com.sun.j3d.utils.geometry.Box b = new com.sun.j3d.utils.geometry.Box(0.4f, length, 0.6f, a);

	    rectTG.addChild(b);



	    TransformGroup pivotTG = tGroup('x', Math.toRadians(90), vZeros, new Vector3d(0.0, 0.0, 0.0));

	    Cylinder c = new Cylinder(0.7f, 1.8f, app1);

	    pivotTG.addChild(c);



	    robotD3TG.addChild(rectTG);

	    robotD3TG.addChild(pivotTG);

	}



	{ //d4 arm

	    float length = d4;//

	    float dia = 1;		

	    float angle = (float) Math.toRadians(40);

	    Appearance a = app2;



	    robotD4TG = tGroup('z', theta4, vZeros, new Vector3d(0.0, d3, 0.0));



	    TransformGroup rectTG = tGroup('z', 0.0f, vZeros, new Vector3d(0.0, (length/2), 0.0));

	    com.sun.j3d.utils.geometry.Cone co = new com.sun.j3d.utils.geometry.Cone(0.4f, length, a);

	    rectTG.addChild(co);



	    TransformGroup pivotTG = tGroup('x', Math.toRadians(90), vZeros, new Vector3d(0.0, 0.0, 0.0));

	    Cylinder c = new Cylinder(0.5f, 1.4f, app1);

	    pivotTG.addChild(c);



	    robotD4TG.addChild(rectTG);

	    robotD4TG.addChild(pivotTG);

	}



	objTrans.addChild(robotBaseTG);

	objTrans.addChild(robotUprightTG);

	robotUprightTG.addChild(robotD2TG);

	robotD2TG.addChild(robotD3TG);

	robotD3TG.addChild(robotD4TG);



	//***************************************************************************

	// Mouse behaviours

	//***************************************************************************



	MouseRotate behavior = new MouseRotate(objMouseTrans);

	objMouseTrans.addChild(behavior);

	behavior.setSchedulingBounds(bounds);

	MouseZoom behavior2 = new MouseZoom(objMouseTrans);

	objMouseTrans.addChild(behavior2);

	behavior2.setSchedulingBounds(bounds);



	//***************************************************************************

	//compile and return base bg

	//***************************************************************************

	objRoot.compile();

	return objRoot;



    }



    /**

     * Method to position the theta sliders

     */

    public void positionThetaSliders(){

	theta1Slider.setValue((int) Math.toDegrees(theta1));

	theta2Slider.setValue((int) Math.toDegrees(theta2));

	theta3Slider.setValue((int) Math.toDegrees(theta3));

	theta4Slider.setValue((int) Math.toDegrees(theta4));

	imapanel.paintImmediately(0, 0, 500,500);

    }



    /**

     * Method to postition the co-ordinate sliders

     */

    public void positionCoOrdSliders(){

	pxSlider.setValue((int) px * 1000);

	pySlider.setValue((int) py * 1000);

	pzSlider.setValue((int) pz * 1000);

	aaSlider.setValue((int) Math.toDegrees(alpha));

	icopanel.paintImmediately(0, 0, 500,500);

    }



   /**

     * Method to update the co-ordinate text fields

     */

    public void updateCoOrdTextFields(){



	posxTextField.setText(String.valueOf(px));

	posyTextField.setText(String.valueOf(py));

	poszTextField.setText(String.valueOf(pz));

	apprTextField.setText(String.valueOf((int) Math.toDegrees(alpha)));



	    tcoerrorlabel.setForeground(Color.green);

	    tcoerrorlabel.setText("           Valid Path            ");

	    tcoerrorlabel.repaint();

    }



    /**

     * Method to postition the arm with the current theta values

     */

    public void positionArm(){

	float angle;



	robotUprightTG = cGroup(robotUprightTG, 'y', theta1, vZeros, new Vector3d(0.0, 0.0, 0.0));



	angle = (float) (Math.PI / 2) - theta2; //zero angle compensation

	robotD2TG = cGroup(robotD2TG, 'z', angle, vZeros, new Vector3d(0.0, d1, 0.0));



	angle = -theta3;

	robotD3TG = cGroup(robotD3TG, 'z', angle, vZeros, new Vector3d(0.0, d2, 0.0));



	angle = -theta4;

	robotD4TG = cGroup(robotD4TG, 'z', angle, vZeros, new Vector3d(0.0, d3, 0.0));

    }







    /**

     * Method to move the arm to the target co-ordinate position values

     */

    public void moveRobot(float tcpvelocity){

	float t1vtemp, t2vtemp, t3vtemp, t4vtemp;

	float tcpdistance = (float) Math.sqrt( sqr( targetpx - startpx ) + sqr( targetpy - startpy ) + sqr( targetpz - startpz ) );

	int steps = (int) (( tcpdistance / tcpvelocity ) * stepspersecond);

	if( steps == 0 ) steps = 10;  //no linear distance but approach angle may have changed



	//calculate step increments

	float xinc = (targetpx - startpx) / steps;

	float yinc = (targetpy - startpy) / steps;

	float zinc = (targetpz - startpz) / steps;

	float aainc = (targetalpha - startalpha) / steps;



	//init averaging values

	float averaget1 = 0.0f,

	    averaget2 = 0.0f,

	    averaget3 = 0.0f,

	    averaget4 = 0.0f; 



	//clear average displayed

	t1aslabel.setText(initavspeed);

	t2aslabel.setText(initavspeed);

	t3aslabel.setText(initavspeed);

	t4aslabel.setText(initavspeed);



	//animation loop

	for(int s = 0; s < steps; s++){

	    px = startpx + ((s+1) * xinc);

	    py = startpy + ((s+1) * yinc);

	    pz = startpz + ((s+1) * zinc);

	    alpha = startalpha + ((s+1) * aainc);



	    //store current thetas

	    float prevt1 = theta1,

		prevt2 = theta2,

		prevt3 = theta3,

		prevt4 = theta4;



	    //calculate next theta values

	    calcThetas();



	    //calculate and display instantaneous velocities

	    t1vtemp = stepspersecond * (float) Math.toDegrees(theta1 - prevt1);

	    t2vtemp = stepspersecond * (float) Math.toDegrees(theta2 - prevt2);

	    t3vtemp = stepspersecond * (float) Math.toDegrees(theta3 - prevt3);

	    t4vtemp = stepspersecond * (float) Math.toDegrees(theta4 - prevt4);



            //text number values

	    t1ivlabel.setText( invelpre + dp2.format(t1vtemp) + invelpost );

	    t2ivlabel.setText( invelpre + dp2.format(t2vtemp) + invelpost );

	    t3ivlabel.setText( invelpre + dp2.format(t3vtemp) + invelpost );

	    t4ivlabel.setText( invelpre + dp2.format(t4vtemp) + invelpost );



	    //bar graphical display

	    if( t1vtemp > 0.0f ) t1velocitybar.setForeground(velocityBarPosColor);

	    else t1velocitybar.setForeground(velocityBarNegColor);

	    t1velocitybar.setValue((int) Math.abs(t1vtemp));



	    if( t2vtemp > 0.0f ) t2velocitybar.setForeground(velocityBarPosColor);

	    else t2velocitybar.setForeground(velocityBarNegColor);

	    t2velocitybar.setValue((int) Math.abs(t2vtemp));



	    if( t3vtemp > 0.0f ) t3velocitybar.setForeground(velocityBarPosColor);

	    else t3velocitybar.setForeground(velocityBarNegColor);

	    t3velocitybar.setValue((int) Math.abs(t3vtemp));



	    if( t4vtemp > 0.0f ) t4velocitybar.setForeground(velocityBarPosColor);

	    else t4velocitybar.setForeground(velocityBarNegColor);

	    t4velocitybar.setValue((int) Math.abs(t4vtemp));



	    //force panel repaint

	    vdsubpanel.paintImmediately(0, 0, 500, 500);



	    //sub-total average values

	    averaget1 = averaget1 + (float)Math.abs(stepspersecond * Math.toDegrees(theta1 - prevt1));

	    averaget2 = averaget2 + (float)Math.abs(stepspersecond * Math.toDegrees(theta2 - prevt2));

	    averaget3 = averaget3 + (float)Math.abs(stepspersecond * Math.toDegrees(theta3 - prevt3));

	    averaget4 = averaget4 + (float)Math.abs(stepspersecond * Math.toDegrees(theta4 - prevt4));



	    //update slider positions

	    positionThetaSliders();

	    positionCoOrdSliders();



	    //update arm position

	    positionArm();



	    //delay

	    try{

		Thread.sleep(1000 / stepspersecond);

	    }

	    catch(InterruptedException ie){

		System.out.println("Interrupted Exception");	 

	    }

	}



	//animation complete



	//zero velocities

	//text values

	t1ivlabel.setText(initinvel);

	t2ivlabel.setText(initinvel);

	t3ivlabel.setText(initinvel);

	t4ivlabel.setText(initinvel);

	//bar graphical display

	t1velocitybar.setValue(0);

	t2velocitybar.setValue(0);

	t3velocitybar.setValue(0);

	t4velocitybar.setValue(0);



	//show average speeds

	if( !Double.isNaN( averaget1 ) )

	    t1aslabel.setText(avspeedpre + dp2.format(averaget1 / (float)steps) + avspeedpost );

	else

	    t1aslabel.setText("None");

	

	if( !Double.isNaN( averaget2 ) )

	    //	    theta2velocityLabel.setText(dp2.format(averaget2 / (float)steps) + "av");

	    t2aslabel.setText(avspeedpre + dp2.format(averaget2 / (float)steps) + avspeedpost );

	else

	    t2aslabel.setText("None");

	

	if( !Double.isNaN( averaget3 ) )

	    //theta3velocityLabel.setText(dp2.format(averaget3 / (float)steps) + "av");

	    t3aslabel.setText(avspeedpre + dp2.format(averaget3 / (float)steps) + avspeedpost );

	else

	    t3aslabel.setText("None");

	

	if( !Double.isNaN( averaget4 ) )

	    //theta4velocityLabel.setText(dp2.format(averaget4 / (float)steps) + "av");

	    t4aslabel.setText(avspeedpre + dp2.format(averaget4 / (float)steps) + avspeedpost );

	else

	    t4aslabel.setText("None");	

    }



    /**

     * Method to test the arms' path to the target co-ordinate position values

     */

    public boolean pathClearTest(int steps){



	//init state

	boolean clear = true;



	//back-up current positions and thetas

	float temptheta1 = theta1,

	    temptheta2 = theta2,

	    temptheta3 = theta3,

	    temptheta4 = theta4,

	    tempalpha = alpha;

	float temppx = px,

	    temppy = py,

	    temppz = pz;



	//calculate increments

	float xinc = (targetpx - startpx) / steps;

	float yinc = (targetpy - startpy) / steps;

	float zinc = (targetpz - startpz) / steps;

	float aainc = (targetalpha - startalpha) / steps;



	//follow path with preferred reach

	for(int s = 0; s < steps; s++){

	    px = startpx + ((s+1) * xinc);

	    py = startpy + ((s+1) * yinc);

	    pz = startpz + ((s+1) * zinc);

	    alpha = startalpha + ((s+1) * aainc);



	    calcThetas();



	    //test for unreachable

	    if( Double.isNaN(theta1) || Double.isNaN(theta2) || Double.isNaN(theta3) || Double.isNaN(theta4) ){

		clear = false;

	    }

	    // if(theta1 > 0.1) clear = false;-debugging



	}



	if( clear == false ){

	    //follow path with alternative reach

	    overridePref = true;

	    clear = true;



	    for(int s = 0; s < steps; s++){

		px = startpx + ((s+1) * xinc);

		py = startpy + ((s+1) * yinc);

		pz = startpz + ((s+1) * zinc);

		alpha = startalpha + ((s+1) * aainc);



		calcThetas();



		//test for unreachable

		if( Double.isNaN(theta1) || Double.isNaN(theta2) || Double.isNaN(theta3) || Double.isNaN(theta4) ){

		    clear = false;

		}

	    }

	}



	//if not clear restore original positions and thetas

	if(clear == false){

	    px = temppx;

	    py = temppy;

	    pz = temppz;

	    theta1 = temptheta1;

	    theta2 = temptheta2;

	    theta3 = temptheta3;

	    theta4 = temptheta4;

	    alpha = tempalpha;

	}



	return clear;

    }



    /**

     * Method to calculate the current theta values from the current target values

     */

    public void calcThetas(){

/*********************** Note from Nick Taylor **************************
The limb lengths of the arm are held in the floats d1, d2, d3 and d4
The new x, y, z co-ordinates of the TCP are held in the floats px, py, pz
The new TCP orientation is held in the float alpha
These eight variables are available for use at this point in the program
The variables which you should determine values for are the floats
theta1, theta2, theta3 and theta4, all in radians
*/
    	
    	
    }



    /** 

     * Method to return the square of a float

     */

    public float sqr(float in){ return (in * in); }



    /**

     * Method to show the target sphere at the co-ordinate position values

     */

    public void showTarget(){

	txTG = cGroup(txTG, 'x', 0.0f, vZeros, new Vector3d(-targetpx, (targetpz+d1), targetpy));

    }



    /**

     * Method to hide the target sphere

     */

    public void hideTarget(){

	txTG = cGroup(txTG, 'x', 0.0f, vZeros, new Vector3d(0.0f, 0.0f, 0.0f));

    }



    /**

     * Method to return a new TransformGroup with a Transform3D for the specified parameters.

     */

    public TransformGroup tGroup(char rotateAxis, double rotateAngle, Vector3d scale, Vector3d trans){



	Transform3D t3d = new Transform3D();



	if(rotateAngle != 0.0){

	    switch(rotateAxis){

	    case 'x': t3d.rotX(rotateAngle);

		break;

	    case 'y': t3d.rotY(rotateAngle);

		break;

	    case 'z': t3d.rotZ(rotateAngle);

		break;

	    }

	}

	if(!scale.equals(vZeros)) t3d.setScale(scale);

	if(!trans.equals(vZeros)) t3d.setTranslation(trans);

	TransformGroup tg = new TransformGroup();

	tg.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);

	tg.setTransform(t3d);

	return tg;

    }



    /**

     * Method to return a passed TransformGroup with its Transform3D set to the specified parameters.

     */

    public TransformGroup cGroup(TransformGroup tg, char rotateAxis, double rotateAngle, Vector3d scale, Vector3d trans){



	Transform3D t3d = new Transform3D();



	if(rotateAngle != 0.0){

	    switch(rotateAxis){

	    case 'x': t3d.rotX(rotateAngle);

		break;

	    case 'y': t3d.rotY(rotateAngle);

		break;

	    case 'z': t3d.rotZ(rotateAngle);

		break;

	    }

	}



	if(!scale.equals(vZeros)) t3d.setScale(scale);

	if(!trans.equals(vZeros)) t3d.setTranslation(trans);

	tg.setTransform(t3d);

	return tg;

    }



    /**

     * Method to return a Group containing the passed Group within a TransformGroup 

     * with its Transform3D set to the specified parameters.

     */

    public Group xGroup(char rotateAxis, double rotateAngle, Vector3d scale, Vector3d trans, Group bg){



	Group tg = tGroup(rotateAxis, rotateAngle, scale, trans);

	tg.addChild(bg);

	return tg;

    }



    //main method

    public static void main(String [] args)

    {

	MainFrame frame = new MainFrame(new robot(),1024,768);



    }



}

