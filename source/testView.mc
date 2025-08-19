import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
using Toybox.Position;
using Toybox.System;

class testView extends WatchUi.View {

    var myTimer;
    var myLocation;
    var counter=0;

    function initialize() {
        View.initialize();
        myLocation = null;
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        myTimer = new Timer.Timer();
        myTimer.start(method(:onTick), 5000, true);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2,  dc.getHeight()/2, Graphics.FONT_LARGE, counter, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        if (myTimer != null) {
            myTimer.stop();
            myTimer = null;
        }
    }

    function onTick() as Void{
        counter +=1;
        System.println("Tick fired!");
        
        if (myLocation != null) {
            System.println("Current location: " + myLocation[0] + ", " + myLocation[1]);
        } else {
            System.println("Location not yet available");
        }

        System.println(myLocation);
        requestUpdate();
    // Update widget content here
    }

    function onPosition(info as Position.Info) as Void{
        if (info.position != null) {
            myLocation = info.position.toDegrees();
            System.println("GPS Update - Lat: " + myLocation[0] + ", Lon: " + myLocation[1]);
        } else {
            System.println("GPS position is null");
        }
        requestUpdate(); // Update display when new location is received
    }
}
