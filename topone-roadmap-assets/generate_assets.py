from PIL import Image, ImageDraw
import os

OUT = 'generated'
os.makedirs(OUT, exist_ok=True)

def img(name, color, size=(256,256)):
    im = Image.new('RGBA', size, color)
    im.save(os.path.join(OUT, name))

# lesson pyramids
img('lesson_locked.png',(40,40,40,255))
img('lesson_available.png',(180,140,60,255))
img('lesson_active.png',(220,180,90,255))
img('lesson_completed.png',(140,110,50,255))

# bricks
img('brick_quiz.png',(200,160,70,255),(128,96))
img('brick_challenge.png',(200,140,60,255),(128,96))

# icons
img('icon_lock.png',(80,80,80,255),(64,64))
img('icon_check.png',(200,170,80,255),(64,64))

print('Assets generated in ./generated')
