const request = require('supertest')
const app = require('../server')
const sequelize = require("../database");
const User = require("../models/user")

describe("Test Authentication", () => {
    // Set the db object to a variable which can be accessed throughout the whole test file
    beforeAll(async () => {
        await sequelize.sync({ force: true })
    })

    afterAll(async () => {
        await sequelize.sync({ force: true })
        await sequelize.drop({ force: true })
        await sequelize.close()
    })

    const user = `admin${Date.now()}authtest`;
    const adminUser=new User({
        fullName: 'Admin',
        email: `${user}@admin.com`,
        password: '123456',
        role: 'admin',
        zipcode: 'zipcode'
    });

    it("Register User", async () => {
        const admin = {
            fullName:'John Doe',
            email: `${user}@admin.com`,
            password: '123456',
            role: 'admin',
            zipcode: '52242'
        };
        await request(app)
        .post("/api/v1/register")
        .send(admin)
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('Thanks for registering');
        });
    });

    it("Deleting User", async () => {
        const admin = {
            fullName:'John Doe',
            email: `${user}@admin.com`,
            password: '123456',
            role: 'admin',
            zipcode: '52242'
        };

        await request(app)
        .post("/api/v1/delete_user")
        .send({'email': 'random@random.com'})
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('User doesnot exist');
        });

        await request(app)
        .post("/api/v1/delete_user")
        .send({'email': admin['email']})
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('User deleted successfully');
        });
    });

    it("Register Multiple Admin", async () => {
        
        await adminUser.save().catch((err)=> {
            console.log("Error: ", err);
        });
        const admin = {
            fullName:'John Doe',
            email: 'admin_2@admin.com',
            password: '123456',
            role: 'admin',
            zipcode: '52242'
        };
        await request(app)
        .post("/api/v1/register")
        .send(admin)
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('An admin user already exists!');
        });
    });

    it("Register Existing User", async () => {
        
        await adminUser.save().catch((err)=> {
            console.log("Error: ", err);
        });
        const admin = {
            fullName:'John Doe',
            email: `${user}@admin.com`,
            password: '123456',
            role: 'admin',
            zipcode: '52242'
        };
        await request(app)
        .post("/api/v1/register")
        .send(admin)
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('User with email already exists!');
        });
    });

    it("Login User", async () => {
        
        await adminUser.save().catch((err)=> {
            console.log("Error: ", err);
        });
        const admin = {
            email: `${user}@admin.com`,
            password: '123456',
        };
        await request(app)
        .post("/api/v1/login")
        .send(admin)
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('Welcome Back!');
        });
    });

    it("Login User with wrong email", async () => {
        
        await adminUser.save().catch((err)=> {
            console.log("Error: ", err);
        });
        const admin = {
            email: 'random@admin.com',
            password: '123456',
        };
        await request(app)
        .post("/api/v1/login")
        .send(admin)
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('Email or password does not match!');
        });
    });

    it("Login User with wrong passowrd", async () => {
        
        await adminUser.save().catch((err)=> {
            console.log("Error: ", err);
        });
        const admin = {
            email: `${user}@admin.com`,
            password: 'random',
        };
        await request(app)
        .post("/api/v1/login")
        .send(admin)
        .then(async (response) => {
            expect(response.statusCode).toBe(200);
            expect(response.body.message).toBe('Email or password does not match!');
        });
    });
    // After all tersts have finished, close the DB connection
    afterAll(async () => {
        await sequelize.close()
    })
});