import ballerina/email;

email:SmtpConfiguration smtpConfig = {
    port: 465
};


public function mailService() returns error?{

email:SmtpClient smtpClient = check new ("smtp.gmail.com", "yudhistervijay@gmail.com", "aarxzdxvixtaidzo", smtpConfig);

email:Message email = {
    to: "kalyan.dey27@gmail.com",
    subject: "Greetings from bigbillion cars",
    body: "Your accounted is created successfully.",
    'from: "yudhistervijay@gmail.com"
    // sender: "yudhistervijay@gmail.com"
};

check smtpClient->sendMessage(email);
}