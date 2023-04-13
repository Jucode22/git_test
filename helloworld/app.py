from flask_sqlalchemy import SQLAlchemy
import pymysql

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:3sbqtrPJ4ww7@db1.ca3rncyuicwv.us-east-2.rds.amazonaws.com/test?charset=utf8mb4'
db = SQLAlchemy(app)

class Timer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    goal = db.Column(db.Text, nullable=False)
    date_created = db.Column(db.Text, nullable=False)

@app.route('/')
def index():
    with app.app_context():
        timers = Timer.query.all()
        return render_template('timers.html', timers=timers)

