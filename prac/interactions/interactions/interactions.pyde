record = 5
radious = 50
snapshot = [[-radious, -radious]]
track_color = color(255, 128, 128)


def setup():
    size(1280, 720)
    print("width:", width)
    print("height:", height)


def draw():
    background(0)
    watchMouse(track_color)
    recordSnapshot(snapshot)


def keyPressed():
    global snapshot
    snapshot = [(mouseX, mouseY)] + snapshot
    if len(snapshot) > record:
        snapshot.pop(-1)


def watchMouse(c):
    fill(c)
    noStroke()
    ellipse(mouseX, mouseY, radious, radious)


def recordSnapshot(s):
    noStroke()
    for i in range(len(s)):
        fill(255 * (1 - i / float(record)))
        ellipse(snapshot[i][0], snapshot[i][1], radious, radious)
