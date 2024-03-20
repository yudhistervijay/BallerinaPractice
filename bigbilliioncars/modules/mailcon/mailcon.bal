import ballerina/email;
import big_billion_cars.user;
import big_billion_cars.model;

email:SmtpConfiguration smtpConfig = {
    port: 465
};


public function mailService(int userId) returns error?{
email:SmtpClient smtpClient = check new ("smtp.gmail.com", "yudhistervijay@gmail.com", "aarxzdxvixtaidzo", smtpConfig);
user:Users users = check user:getUsers(userId);
string gmail=users.email;

email:Message email = {
    to: gmail,
    subject: "Greetings from Big Billion Cars",
    body: "CAR details created successfully.",
    'from: "yudhistervijay@gmail.com"
};

check smtpClient->sendMessage(email);
}