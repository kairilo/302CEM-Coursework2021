import mysql.connector
from flask import Flask, render_template, request, redirect, url_for, session
from pandas import json_normalize
app = Flask(__name__)
app.secret_key = "secretkkey"
sqlconn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="common"
)

def validate_string(val):
   if val != None:
        if type(val) is int:
            #for x in val:
            #   print(x)
            return str(val).encode('utf-8')
        else:
            return val

@app.route('/', methods=['GET', 'POST'])
def index():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        # find account
        cursor = sqlconn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM login_info WHERE username = %s AND password = %s', (username, password,))
        account = cursor.fetchone()
        # if exist
        if account:
            session['loggedin'] = True
            session['username'] = account['username']
            session['type'] = account['type']
            if session['type'] == "Shop":
                return redirect(url_for('shopHomepage'))
            elif session['type'] == "Delivery":
                return redirect(url_for('deliveryHomepage'))
        else:
            # if not exist
            msg = 'Incorrect username/password!'
    return render_template('login.html', msg=msg)


@app.route('/delivery', methods=['GET', 'POST'])
def deliveryHomepage():
    if 'loggedin' not in session:
        return redirect(url_for('index'))
    else:
        cursor = sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info`")
        output = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("deliveryHomepage.html", output=output)


@app.route('/shop', methods=['GET', 'POST'])
def shopHomepage():
    if 'loggedin' not in session:
        return redirect(url_for('index'))
    elif request.method =="POST":
        render_template('pedit.html')

    else:
        cursor = sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info`")
        output = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
    return render_template("shopHomepage.html", output=output)
@app.route('/dsearchorderno', methods = ['POST','GET'])
def dsearchorderno():
    if request.method == "POST":
        info = request.form
        SearchInHTML = info['search'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        session['search']=info['search']
        cursor=sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info` WHERE `order_no` = %s", (SearchInHTML,))
        records = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("searchorderno.html", records=records)
    return render_template('searchorderno.html')


@app.route('/dsearchcustomername', methods = ['POST','GET'])
def dsearchcustomername():
    if request.method == "POST":
        info = request.form
        SearchInHTML = info['search'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        cursor=sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info` WHERE `customer_name` = %s", (SearchInHTML,))
        records = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("searchcustomername.html", records=records)
    return render_template('searchcustomername.html')


@app.route('/dsearchproductname', methods = ['POST','GET'])
def dsearchproductname():
    if request.method == "POST":
        info = request.form
        SearchInHTML = info['search'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        cursor=sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info` WHERE `product_name` = %s", (SearchInHTML,))
        records = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("searchproductname.html", records=records)
    return render_template('searchproductname.html')


@app.route('/ddel', methods = ['POST','GET'])
def ddele():
    if request.method == "POST":
        info = request.form
        dele = info['dele'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        cursor=sqlconn.cursor()
        cursor.execute("DELETE FROM `order_info` WHERE `order_no` = %s", (dele,))
        sqlconn.commit()
        cursor.close()
        return render_template('searchorderno.html')
    return render_template('searchorderno.html')

@app.route('/ssearchorderno', methods = ['POST','GET'])
def ssearchorderno():
    if request.method == "POST":
        info = request.form
        SearchInHTML = info['search'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        session['search']=info['search']
        cursor=sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info` WHERE `order_no` = %s", (SearchInHTML,))
        records = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("ssearchorderno.html", records=records)
    return render_template('ssearchorderno.html')


@app.route('/ssearchcustomername', methods = ['POST','GET'])
def ssearchcustomername():
    if request.method == "POST":
        info = request.form
        SearchInHTML = info['search'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        cursor=sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info` WHERE `customer_name` = %s", (SearchInHTML,))
        records = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("ssearchcustomername.html", records=records)
    return render_template('ssearchcustomername.html')


@app.route('/ssearchproductname', methods = ['POST','GET'])
def ssearchproductname():
    if request.method == "POST":
        info = request.form
        SearchInHTML = info['search'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        cursor=sqlconn.cursor()
        cursor.execute("SELECT * FROM `order_info` WHERE `product_name` = %s", (SearchInHTML,))
        records = cursor.fetchall()
        sqlconn.commit()
        cursor.close()
        return render_template("ssearchproductname.html", records=records)
    return render_template('ssearchproductname.html')


@app.route('/sdel', methods = ['POST','GET'])
def sdele():
    if request.method == "POST":
        info = request.form
        dele = info['dele'] #GET HTML>FORM>INPUT>NAME STORE INTO VARIABLE
        cursor=sqlconn.cursor()
        cursor.execute("DELETE FROM `order_info` WHERE `order_no` = %s", (dele,))
        sqlconn.commit()
        cursor.close()
        return render_template('ssearchorderno.html')
    return render_template('ssearchorderno.html')


@app.route('/insert',methods=['POST','GET'])
def insert():
    return render_template('insertneworder.html')


@app.route("/insertcomplete", methods = ['POST','GET'])
def insertcomp():
    if request.method =='POST':
        info = request.form
        jsoncontent=[{'order_no':info['order_no'],'order_date':info['order_date'],'product_name':info['product_name'],'quantity':info['quantity'],'price':info['price'],'customer_name':info['customer_name'],'customer_tel':info['customer_tel'],'customer_address':info['customer_address']}]
        for i, item in enumerate(jsoncontent):
            order_no = validate_string(item.get("order_no", None))
            order_date = validate_string(item.get("order_date", None))
            product_name = validate_string(item.get("product_name", None))
            quantity=validate_string(item.get("quantity", None))
            price=validate_string(item.get("price", None))
            customer_name=validate_string(item.get("customer_name", None))
            customer_tel=validate_string(item.get("customer_tel", None))
            customer_address=validate_string(item.get("customer_address", None))
        cursor = sqlconn.cursor()
        cursor.execute("INSERT INTO `order_info`(`order_no`, `order_date`, `product_name`, `quantity`, `price`, `customer_name`, `customer_tel`, `customer_address`)"
                       " VALUES (%s,%s,%s,%s,%s,%s,%s,%s)", (order_no, order_date, product_name, quantity, price, customer_name, customer_tel, customer_address))
        sqlconn.commit()
    return render_template('complete.html')


@app.route("/pedit", methods=['POST', 'GET'])
def pedit():
    cursor = sqlconn.cursor()
    order_no = request.form['order_no']
    cursor.execute("SELECT * FROM `order_info` WHERE `order_no` = %s",(order_no,))
    output = cursor.fetchone()
    sqlconn.commit()
    cursor.close()
    return render_template('pedit.html', output=output)


@app.route("/peditcomplete", methods=['POST', 'GET'])
def peditcomp():
    if request.method == 'POST':
        info = request.form
        jsoncontent=[{'order_no':info['order_no'],'order_date':info['order_date'],'product_name':info['product_name'],'quantity':info['quantity'],'price':info['price'],'customer_name':info['customer_name'],'customer_tel':info['customer_tel'],'customer_address':info['customer_address']}]
        for i, item in enumerate(jsoncontent):
            order_no = validate_string(item.get("order_no", None))
            order_date = validate_string(item.get("order_date", None))
            product_name = validate_string(item.get("product_name", None))
            quantity=validate_string(item.get("quantity", None))
            price=validate_string(item.get("price", None))
            customer_name=validate_string(item.get("customer_name", None))
            customer_tel=validate_string(item.get("customer_tel", None))
            customer_address=validate_string(item.get("customer_address", None))
        cursor = sqlconn.cursor()
        cursor.execute(
            "UPDATE order_info SET order_date=%s, product_name= %s, quantity=%s, price= %s, customer_name=%s, customer_tel=%s, customer_address=%s WHERE order_no=%s",
            (order_date, product_name, quantity, price, customer_name,customer_tel,customer_address,order_no))
        sqlconn.commit()
    return render_template('peditcomplete.html')
@app.route("/dedit",methods=['POST', 'GET'])
def dedit():
    cursor = sqlconn.cursor()
    order_no = request.form['order_no']
    session['order_no']=order_no
    cursor.execute("SELECT * FROM `order_info` WHERE `order_no` = %s",(order_no,))
    output = cursor.fetchone()
    sqlconn.commit()
    cursor.close()
    return render_template('dedit.html', output=output)


@app.route("/deditcomplete", methods=['POST', 'GET'])
def deditcomp():
    if request.method == 'POST':
        info = request.form
        jsoncontent=[{'order_no':session['order_no'],'delivery_ref_no':info['delivery_ref_no'],'receive_package_date':info['receive_package_date'],'total_weight_kg':info['total_weight_kg'],'total_delivery_price':info['total_delivery_price'],'in_charge_delivery_man':info['in_charge_delivery_man'],'contact_tel':info['contact_tel'],'expected_delivery_date':info['expected_delivery_date'],'actual_delivery_datetime':info['expected_delivery_date']}]
        for i, item in enumerate(jsoncontent):
            order_no = validate_string(item.get("order_no", None))
            delivery_ref_no = validate_string(item.get("delivery_ref_no", None))
            receive_package_date= validate_string(item.get("receive_package_date", None))
            total_weight_kg=validate_string(item.get("total_weight_kg", None))
            total_delivery_price=validate_string(item.get("total_delivery_price", None))
            in_charge_delivery_man=validate_string(item.get("in_charge_delivery_man", None))
            contact_tel=validate_string(item.get("contact_tel", None))
            expected_delivery_date=validate_string(item.get("expected_delivery_date", None))
            actual_delivery_datetime=validate_string(item.get("actual_delivery_datetime", None))
        cursor = sqlconn.cursor()
        cursor.execute(
            "UPDATE order_info SET delivery_ref_no=%s, receive_package_date=%s, total_weight_kg=%s, total_delivery_price=%s, in_charge_delivery_man=%s, contact_tel=%s, expected_delivery_date=%s, actual_delivery_datetime=%s WHERE order_no=%s"
            , (delivery_ref_no, receive_package_date, total_weight_kg, total_delivery_price,in_charge_delivery_man, contact_tel, expected_delivery_date, actual_delivery_datetime,order_no))
        cursor.execute(
            "INSERT INTO `update_history`(`order_no`, `delivery_ref_no`, `receive_package_date`, `total_weight_kg`, `total_delivery_price`, `in_charge_delivery_man`, `contact_tel`,`expected_delivery_date`,`actual_delivery_datetime`)"
            "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)", (order_no, delivery_ref_no, receive_package_date, total_weight_kg, total_delivery_price,in_charge_delivery_man, contact_tel, expected_delivery_date, actual_delivery_datetime))

        sqlconn.commit()
    return render_template('deditcomplete.html')


@app.route('/logout')
def logout():
    # erase logged in dession item
    session.pop('loggedin', None)
    session.pop('username', None)

    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)