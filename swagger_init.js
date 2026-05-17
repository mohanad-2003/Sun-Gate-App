
window.onload = function() {
  // Build a system
  var url = window.location.search.match(/url=([^&]+)/);
  if (url && url.length > 1) {
    url = decodeURIComponent(url[1]);
  } else {
    url = window.location.origin;
  }
  var options = {
  "swaggerDoc": {
    "openapi": "3.0.3",
    "info": {
      "title": "SunGate API",
      "description": "Production REST API for the SunGate platform (auth, users, marketplace, social, articles, notifications).\n\n## News updates (home feed)\nPublic endpoints for the home/news surface:\n- **`GET /weather`** — current weather (WeatherAPI proxy)\n- **`GET /api/articles`** — paginated news articles\n- **`GET /api/articles/{articleId}`** — single article detail\n\n## Documentation endpoints\n- **Swagger UI** (Try it out): `GET /api-docs`\n- **OpenAPI JSON** (same specification, with **runtime server URLs**): `GET /openapi.json`\n- **Static export** (from repo YAML only): `npm run docs:export` → `openapi/openapi.snapshot.json`\n\n## User registration (`PendingUser`)\nEmail/password signup stores profile data in a **`PendingUser`** document until the email is verified.\nNothing is inserted into **`User`** until **`POST /api/auth/verify-email`** succeeds.\n\n- **Register** saves or replaces the pending row for that email (new verification code each time).\n- **Verify email** creates the **`User`** (email already verified), deletes the pending row, then **`POST /api/auth/assing-password`** sets the password.\n- **Resend verification** applies only while a pending signup exists (**404** if the email is absent from pending storage).\n- Pending rows use a MongoDB **TTL index** on `expiresAt` (lifetime is `max` of **`EMAIL_VERIFY_TTL_MS`** and **`PENDING_USER_TTL_MS`** in server config).\n\nResponses use **`sanitizeUser`**: flattened **`isVerifiedEmail`** / **`isVerifiedWhatsApp`**, never passwords or verification token fields.\n\n## Authentication\nMost user-facing endpoints require a **JWT Bearer token** in the `Authorization` header.\nObtain tokens via **`POST /api/auth/login`** (email + password for all roles) or **`POST /api/auth/google-login`**.\nCompany portal users use the same login after their account is **active** (same credentials as registration).\n\n```\nAuthorization: Bearer <accessToken>\n```\n\nThe **access token** includes `sub`, `userId`, `email`, and `role` claims and expires after 7 days by default (configurable).\n**Login** also returns `refreshToken` in the JSON body and sets an `httpOnly` cookie named `refreshToken` for browser clients (`secure`, `sameSite: strict`, aligned with refresh token TTL, default 30 days).\n\n**`POST /api/auth/company/login`** is deprecated and behaves like **`POST /api/auth/login`** (same response).\n\n## Roles\nJWT payloads are tied to users with a `role`: `user`, `engineer`, `company`, or `admin`.\nSome routes require a specific role (e.g. company profile CRUD for `company`).\n\n## Error Handling\nAll error responses share a consistent structure:\n```json\n{\n  \"success\": false,\n  \"status\": \"fail\" | \"error\",\n  \"message\": \"Human-readable description\"\n}\n```\n- `fail` — client-side error (4xx)\n- `error` — server-side error (5xx)\n",
      "version": "1.0.0",
      "contact": {
        "name": "SunGate Team"
      }
    },
    "servers": [
      {
        "url": "http://localhost:3000",
        "description": "Local development (PORT from environment, currently 3000)."
      },
      {
        "url": "https://graduationproject-production-56ab.up.railway.app",
        "description": "Production (Railway). Override with PUBLIC_API_URL if your deploy URL changes."
      }
    ],
    "tags": [
      {
        "name": "Health",
        "description": "Server health monitoring"
      },
      {
        "name": "News updates",
        "description": "Public home/feed data: current weather and published articles (no auth required for read).\nUse **`GET /weather`** for conditions and **`GET /api/articles`** for paginated news content.\n"
      },
      {
        "name": "Auth",
        "description": "Registration (pending-then-verify flow), login, email verification, and password management.\nLocal signup uses **`PendingUser`** until email verification promotes the account into **`User`**.\n"
      },
      {
        "name": "Users",
        "description": "Authenticated user profile operations (including account deletion)"
      },
      {
        "name": "Admin accounts",
        "description": "Admin-only controls for suspending, activating, and deleting user accounts"
      },
      {
        "name": "Companies",
        "description": "Company profiles, pagination, logo uploads, and public listings of linked engineers, products, and posts.\n"
      },
      {
        "name": "Engineers",
        "description": "Engineer registrations linked to companies (`engineer` / `admin` for creates)"
      },
      {
        "name": "Products",
        "description": "Product listings with images (Cloudinary) and marketplace filters"
      },
      {
        "name": "Reservations",
        "description": "Buyer–seller reservation workflow for products"
      },
      {
        "name": "Social",
        "description": "Posts, comments, and likes"
      },
      {
        "name": "Follows",
        "description": "Follow and unfollow users; list followers and following"
      },
      {
        "name": "Articles",
        "description": "Article CRUD and cover uploads (admin/author). Public **read** endpoints are also tagged **News updates**.\n"
      },
      {
        "name": "Notifications",
        "description": "In-app and FCM-backed notifications list"
      },
      {
        "name": "Company auth",
        "description": "Company portal onboarding: OTP verification and multipart registration with official document,\nadmin approval / payment workflow. Credentials live on **`User`** (role `company`); profile and review state live on **`Company`**. **`POST /api/auth/company/login`** is deprecated — use **`POST /api/auth/login`**. Mounted under **`/api/auth/company`** (same rate limiter as user auth).\n"
      }
    ],
    "components": {
      "securitySchemes": {
        "BearerAuth": {
          "type": "http",
          "scheme": "bearer",
          "bearerFormat": "JWT",
          "description": "JWT access token obtained from login endpoints"
        },
        "PasswordResetSessionAuth": {
          "type": "http",
          "scheme": "bearer",
          "bearerFormat": "JWT",
          "description": "Short-lived JWT returned by `POST /api/auth/verify-password-reset-token` after the email\ncode is validated (`purpose: password_reset`, expires in ~15 minutes). Use this header for\n`POST /api/auth/reset-password` — not the same as the login access token.\n"
        }
      },
      "parameters": {
        "Page": {
          "name": "page",
          "in": "query",
          "description": "Page number (1-based)",
          "schema": {
            "type": "integer",
            "minimum": 1,
            "default": 1
          }
        },
        "Limit20": {
          "name": "limit",
          "in": "query",
          "description": "Page size (capped per route in validation)",
          "schema": {
            "type": "integer",
            "minimum": 1,
            "maximum": 50,
            "default": 10
          }
        },
        "LimitFollow": {
          "name": "limit",
          "in": "query",
          "schema": {
            "type": "integer",
            "minimum": 1,
            "maximum": 100,
            "default": 20
          }
        }
      },
      "schemas": {
        "RegisterRequest": {
          "type": "object",
          "required": [
            "fullName",
            "email",
            "birthDate"
          ],
          "description": "Mirrors `registerSchema` in `src/modules/auth/auth.validation.js`. Password is **not** included in this payload.\nCreates or updates a **`PendingUser`** (no **`User`** row yet) and emails a six-digit code.\n",
          "properties": {
            "fullName": {
              "type": "string",
              "minLength": 2,
              "maxLength": 100,
              "example": "Ahmad Khalil"
            },
            "email": {
              "type": "string",
              "format": "email",
              "description": "Stored lowercased",
              "example": "ahmad.khalil@example.com"
            },
            "location": {
              "type": "string",
              "maxLength": 255,
              "description": "Optional (`Joi` does not mark this field as required).",
              "example": "Amman, Jordan"
            },
            "birthDate": {
              "type": "string",
              "format": "date",
              "description": "ISO 8601 date (e.g. birthday); Joi accepts ISO date strings / Date input",
              "example": "1998-06-15"
            },
            "gender": {
              "type": "string",
              "enum": [
                "male",
                "female"
              ],
              "example": "male"
            }
          }
        },
        "AssingPasswordRequest": {
          "type": "object",
          "required": [
            "email",
            "password"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email",
              "description": "Same email used at registration",
              "example": "ahmad.khalil@example.com"
            },
            "password": {
              "type": "string",
              "format": "password",
              "minLength": 8,
              "maxLength": 128,
              "example": "MyS3cur3P@ss!"
            }
          }
        },
        "AssingPasswordResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "properties": {
                "user": {
                  "$ref": "#/components/schemas/User"
                },
                "message": {
                  "type": "string",
                  "example": "Password set successfully. then you can sign in."
                }
              }
            }
          }
        },
        "LoginRequest": {
          "type": "object",
          "required": [
            "email",
            "password"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email",
              "example": "ahmad.khalil@example.com"
            },
            "password": {
              "type": "string",
              "format": "password",
              "minLength": 8,
              "maxLength": 128,
              "example": "MyS3cur3P@ss!"
            }
          }
        },
        "GoogleLoginRequest": {
          "type": "object",
          "required": [
            "idToken"
          ],
          "properties": {
            "idToken": {
              "type": "string",
              "description": "Google OAuth2 ID token from the client SDK",
              "example": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
            }
          }
        },
        "VerifyEmailRequest": {
          "type": "object",
          "required": [
            "token",
            "email"
          ],
          "properties": {
            "token": {
              "type": "string",
              "description": "Six-digit verification code sent to the user's email",
              "example": "482917"
            },
            "email": {
              "type": "string",
              "format": "email",
              "example": "ahmad.khalil@example.com"
            }
          }
        },
        "ResendVerificationRequest": {
          "type": "object",
          "required": [
            "email"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email",
              "description": "Email used on **`/register`**. A new six-digit code is generated and emailed; the pending row is refreshed.\nReturns **404** if there is no pending registration for this address (e.g. already verified and promoted to **`User`**).\n",
              "example": "ahmad.khalil@example.com"
            }
          }
        },
        "ForgotPasswordRequest": {
          "type": "object",
          "required": [
            "email"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email",
              "example": "ahmad.khalil@example.com"
            }
          }
        },
        "ResendPasswordResetTokenRequest": {
          "type": "object",
          "required": [
            "email"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email",
              "description": "Email address tied to the account. A new six-digit reset code is generated and emailed; any previous code is invalidated.",
              "example": "ahmad.khalil@example.com"
            }
          }
        },
        "VerifyPasswordResetTokenRequest": {
          "type": "object",
          "required": [
            "email",
            "token"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email"
            },
            "token": {
              "type": "string",
              "description": "Six-digit reset code from email",
              "example": "739201"
            }
          }
        },
        "VerifyPasswordResetTokenResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "properties": {
                "message": {
                  "type": "string",
                  "example": "Password reset token verified"
                },
                "passwordResetToken": {
                  "type": "string",
                  "description": "Bearer token for POST /api/auth/reset-password (15m TTL)"
                }
              }
            }
          }
        },
        "ResetPasswordRequest": {
          "type": "object",
          "required": [
            "password"
          ],
          "properties": {
            "password": {
              "type": "string",
              "format": "password",
              "minLength": 8,
              "maxLength": 128,
              "description": "New password (requires PasswordResetSessionAuth, not the email code)",
              "example": "N3wSecur3P@ss!"
            }
          }
        },
        "UpdateMeRequest": {
          "type": "object",
          "minProperties": 1,
          "description": "At least one property required. Mirrors `PATCH /api/users/me` Joi validation (`updateMeSchema`).\n",
          "properties": {
            "fullName": {
              "type": "string",
              "minLength": 2,
              "maxLength": 200,
              "example": "Ahmad Khalil Al-Majali"
            },
            "birthDate": {
              "type": "string",
              "format": "date",
              "description": "ISO 8601 date (stored as UTC midnight)",
              "example": "1998-06-15"
            },
            "gender": {
              "type": "string",
              "enum": [
                "male",
                "female"
              ],
              "example": "male"
            },
            "location": {
              "type": "string",
              "maxLength": 255,
              "example": "Amman, Jordan"
            },
            "phoneWhatsapp": {
              "type": "string",
              "maxLength": 30,
              "example": "+962791234567"
            }
          }
        },
        "ChangePasswordRequest": {
          "type": "object",
          "required": [
            "oldPassword",
            "newPassword"
          ],
          "properties": {
            "oldPassword": {
              "type": "string",
              "format": "password",
              "minLength": 8,
              "maxLength": 128,
              "example": "MyS3cur3P@ss!"
            },
            "newPassword": {
              "type": "string",
              "format": "password",
              "minLength": 8,
              "maxLength": 128,
              "example": "Ev3nM0reSecur3!"
            }
          }
        },
        "User": {
          "type": "object",
          "description": "User shape returned by **`sanitizeUser`** (auth and user routes). Sensitive fields are omitted\n(`password`, verification tokens, `fcmToken`, `googleId`, `authProvider`). Verification is **flattened**\nto boolean flags — not nested `verification.*` in JSON.\n",
          "properties": {
            "_id": {
              "type": "string",
              "example": "664f1a2b3c4d5e6f7a8b9c0d"
            },
            "fullName": {
              "type": "string",
              "example": "Ahmad Khalil"
            },
            "email": {
              "type": "string",
              "format": "email",
              "example": "ahmad.khalil@example.com"
            },
            "role": {
              "type": "string",
              "enum": [
                "user",
                "engineer",
                "company",
                "admin"
              ],
              "example": "user"
            },
            "accountStatus": {
              "type": "string",
              "enum": [
                "active",
                "suspended"
              ],
              "description": "Admin-managed account access state. Suspended accounts cannot sign in or use existing tokens.",
              "example": "active"
            },
            "profileImageUrl": {
              "type": "string",
              "format": "uri",
              "nullable": true,
              "description": "Avatar URL (e.g. from Google OAuth or profile upload)"
            },
            "isVerifiedEmail": {
              "type": "boolean",
              "description": "Same as `verification.email.isVerified` in the database; always exposed as a top-level flag in API JSON.",
              "example": true
            },
            "isVerifiedWhatsApp": {
              "type": "boolean",
              "description": "Same as `verification.whatsapp.isVerified` in the database.",
              "example": false
            },
            "birthDate": {
              "type": "string",
              "format": "date-time",
              "nullable": true,
              "example": "1998-06-15T00:00:00.000Z"
            },
            "gender": {
              "type": "string",
              "enum": [
                "male",
                "female"
              ],
              "nullable": true,
              "example": "male"
            },
            "location": {
              "type": "string",
              "nullable": true,
              "example": "Amman, Jordan"
            },
            "phoneWhatsapp": {
              "type": "string",
              "nullable": true,
              "example": "+962791234567"
            },
            "createdAt": {
              "type": "string",
              "format": "date-time",
              "example": "2025-12-01T10:30:00.000Z"
            },
            "updatedAt": {
              "type": "string",
              "format": "date-time",
              "example": "2025-12-05T14:20:00.000Z"
            }
          }
        },
        "PendingRegistrationPreview": {
          "type": "object",
          "description": "Returned from **`POST /api/auth/register`** while the account exists only as **`PendingUser`**.\nNo **`_id`** (not a **`User`** yet). Mirrors `sanitizePendingRegistration` — no verification tokens or password.\n",
          "properties": {
            "email": {
              "type": "string",
              "format": "email",
              "example": "ahmad.khalil@example.com"
            },
            "fullName": {
              "type": "string",
              "example": "Ahmad Khalil"
            },
            "role": {
              "type": "string",
              "enum": [
                "user"
              ],
              "example": "user"
            },
            "phoneWhatsapp": {
              "type": "string",
              "nullable": true,
              "example": null
            },
            "profileImageUrl": {
              "type": "string",
              "nullable": true,
              "example": null
            },
            "isVerifiedEmail": {
              "type": "boolean",
              "example": false
            },
            "isVerifiedWhatsApp": {
              "type": "boolean",
              "example": false
            },
            "birthDate": {
              "type": "string",
              "format": "date-time",
              "example": "1998-06-15T00:00:00.000Z"
            },
            "gender": {
              "type": "string",
              "enum": [
                "male",
                "female"
              ],
              "nullable": true,
              "example": "male"
            },
            "location": {
              "type": "string",
              "nullable": true,
              "example": "Amman, Jordan"
            },
            "createdAt": {
              "type": "string",
              "format": "date-time"
            },
            "updatedAt": {
              "type": "string",
              "format": "date-time"
            }
          }
        },
        "TokenPair": {
          "type": "object",
          "properties": {
            "accessToken": {
              "type": "string",
              "description": "JWT access token (7-day expiry by default)",
              "example": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjRmMWEyYjNjNGQ1ZTZmN2E4YjljMGQiLCJpYXQiOjE3MzI4NzUwMDB9.abc123"
            },
            "refreshToken": {
              "type": "string",
              "description": "JWT refresh token (30-day expiry by default)",
              "example": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjRmMWEyYjNjNGQ1ZTZmN2E4YjljMGQiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTczMjg3NTAwMH0.xyz789"
            }
          }
        },
        "RegisterResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "properties": {
                "user": {
                  "$ref": "#/components/schemas/PendingRegistrationPreview"
                },
                "message": {
                  "type": "string",
                  "example": "Registration successful. Please verify your email"
                }
              }
            }
          }
        },
        "VerifyEmailResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "properties": {
                "user": {
                  "$ref": "#/components/schemas/User"
                },
                "message": {
                  "type": "string",
                  "example": "Email verified. please assign your password"
                }
              }
            }
          }
        },
        "LoginResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "$ref": "#/components/schemas/UnifiedAuthPayload"
            }
          }
        },
        "GoogleLoginResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "$ref": "#/components/schemas/UnifiedAuthPayload"
            }
          }
        },
        "UnifiedAuthPayload": {
          "type": "object",
          "properties": {
            "userId": {
              "type": "string",
              "example": "664f1a2b3c4d5e6f7a8b9c0d"
            },
            "name": {
              "type": "string",
              "example": "Ahmad Khalil"
            },
            "email": {
              "type": "string",
              "format": "email"
            },
            "role": {
              "type": "string",
              "enum": [
                "user",
                "engineer",
                "company",
                "admin"
              ]
            },
            "accessToken": {
              "type": "string",
              "example": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
            },
            "refreshToken": {
              "type": "string",
              "example": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
            }
          }
        },
        "MessageResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "properties": {
                "message": {
                  "type": "string"
                }
              }
            }
          }
        },
        "UserResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "$ref": "#/components/schemas/User"
            }
          }
        },
        "ProfilePictureResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "properties": {
                "imageUrl": {
                  "type": "string",
                  "format": "uri",
                  "description": "Stored on the user as `profileImageUrl`; echoed here as `imageUrl`",
                  "example": "https://res.cloudinary.com/demo/image/upload/v1/users/profiles/abc123.jpg"
                }
              }
            }
          }
        },
        "HealthResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "message": {
              "type": "string",
              "example": "API is healthy"
            }
          }
        },
        "ErrorResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": false
            },
            "status": {
              "type": "string",
              "enum": [
                "fail",
                "error"
              ],
              "description": "`fail` for 4xx client errors, `error` for 5xx server errors",
              "example": "fail"
            },
            "message": {
              "type": "string",
              "example": "Descriptive error message"
            }
          }
        },
        "ValidationErrorResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": false
            },
            "status": {
              "type": "string",
              "example": "fail"
            },
            "message": {
              "type": "string",
              "example": "\"email\" must be a valid email"
            }
          }
        },
        "FcmTokenRequest": {
          "type": "object",
          "properties": {
            "fcmToken": {
              "type": "string",
              "nullable": true,
              "description": "Firebase Cloud Messaging device token; omit or empty to clear",
              "maxLength": 2048
            }
          }
        },
        "CreateCompanyRequest": {
          "type": "object",
          "description": "Matches `createCompanySchema` in **`src/models/validations/company.validation.js`**.\nUsed for authenticated **`company`** or **`admin`** users creating an additional marketplace **Company** profile (distinct from **`/api/auth/company/register`** portal onboarding, which also creates **`User` + `Company`**).\n",
          "required": [
            "ownerName",
            "dateOfEstablishment"
          ],
          "properties": {
            "ownerName": {
              "type": "string",
              "minLength": 2,
              "maxLength": 200
            },
            "address": {
              "type": "string",
              "maxLength": 500,
              "nullable": true,
              "description": "Optional; empty string or null allowed"
            },
            "phone": {
              "type": "string",
              "maxLength": 40,
              "nullable": true,
              "description": "Optional; empty string or null allowed"
            },
            "description": {
              "type": "string",
              "maxLength": 2000,
              "nullable": true,
              "description": "Optional company profile description"
            },
            "dateOfEstablishment": {
              "type": "string",
              "format": "date",
              "description": "Date the company was established (ISO date, not in the future)"
            }
          }
        },
        "UpdateCompanyRequest": {
          "type": "object",
          "description": "Partial update; **at least one** field required (`updateCompanySchema` in **`src/models/validations/company.validation.js`**).\nIncludes optional **`subscription`** for plan window metadata (plan name + ISO dates).\n",
          "minProperties": 1,
          "properties": {
            "ownerName": {
              "type": "string",
              "minLength": 2,
              "maxLength": 200
            },
            "address": {
              "type": "string",
              "maxLength": 500,
              "nullable": true
            },
            "phone": {
              "type": "string",
              "maxLength": 40,
              "nullable": true
            },
            "description": {
              "type": "string",
              "maxLength": 2000,
              "nullable": true
            },
            "dateOfEstablishment": {
              "type": "string",
              "format": "date",
              "description": "Date the company was established (ISO date, not in the future)"
            },
            "subscription": {
              "type": "object",
              "description": "Subscription metadata (all sub-fields optional in payload)",
              "properties": {
                "plan": {
                  "type": "string",
                  "maxLength": 64
                },
                "startDate": {
                  "type": "string",
                  "format": "date-time"
                },
                "endDate": {
                  "type": "string",
                  "format": "date-time"
                }
              }
            }
          }
        },
        "CompanySendOtpRequest": {
          "type": "object",
          "required": [
            "email"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email"
            }
          }
        },
        "CompanyVerifyOtpRequest": {
          "type": "object",
          "required": [
            "email",
            "otp"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email"
            },
            "otp": {
              "type": "string",
              "pattern": "^[0-9]{6}$"
            }
          }
        },
        "CompanyLoginRequest": {
          "type": "object",
          "required": [
            "email",
            "password"
          ],
          "properties": {
            "email": {
              "type": "string",
              "format": "email"
            },
            "password": {
              "type": "string",
              "minLength": 8,
              "maxLength": 128
            }
          }
        },
        "CompanyRegistrationInfoData": {
          "type": "object",
          "properties": {
            "flow": {
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "privacyPolicy": {
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "documentGuidance": {
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "otpTtlMinutes": {
              "type": "integer",
              "description": "OTP validity window in minutes (from `COMPANY_OTP_TTL_MS`, default 15)"
            }
          }
        },
        "CompanyVerifyOtpSuccessData": {
          "type": "object",
          "properties": {
            "registrationToken": {
              "type": "string",
              "description": "Short-lived JWT — send as `registrationToken` field with multipart registration"
            },
            "message": {
              "type": "string"
            }
          }
        },
        "CompanyRegisterSuccessData": {
          "type": "object",
          "properties": {
            "company": {
              "type": "object",
              "description": "Created **`Company`** document (no password). Includes marketplace/profile fields such as\n**`companyName`**, **`ownerName`**, **`address`**, **`dateOfEstablishment`**, **`documentUrl`**, **`logo`**, **`status`** (`pending_review`), timestamps, etc. Cloudinary **`publicId`** values are not persisted—only the resulting URLs are stored.\n",
              "additionalProperties": true
            },
            "message": {
              "type": "string"
            }
          }
        },
        "CreateEngineerRequest": {
          "type": "object",
          "required": [
            "companyId"
          ],
          "properties": {
            "companyId": {
              "type": "string",
              "description": "MongoDB ObjectId (24 hex chars)",
              "pattern": "^[a-fA-F0-9]{24}$"
            },
            "yearsOfExperience": {
              "type": "integer",
              "minimum": 0,
              "maximum": 80
            },
            "certificate": {
              "type": "string",
              "maxLength": 500
            }
          }
        },
        "UpdateEngineerRequest": {
          "type": "object",
          "minProperties": 1,
          "properties": {
            "yearsOfExperience": {
              "type": "integer",
              "minimum": 0,
              "maximum": 80
            },
            "certificate": {
              "type": "string",
              "maxLength": 500
            },
            "rating": {
              "type": "number",
              "minimum": 0,
              "maximum": 5
            }
          }
        },
        "CreateProductRequest": {
          "type": "object",
          "required": [
            "title",
            "category",
            "price",
            "condition"
          ],
          "properties": {
            "title": {
              "type": "string",
              "maxLength": 200
            },
            "description": {
              "type": "string",
              "maxLength": 5000
            },
            "category": {
              "type": "string",
              "maxLength": 120
            },
            "price": {
              "type": "number",
              "minimum": 0
            },
            "condition": {
              "type": "string",
              "enum": [
                "new",
                "used",
                "like_new",
                "good",
                "fair"
              ]
            },
            "status": {
              "type": "string",
              "enum": [
                "draft",
                "active",
                "sold",
                "reserved",
                "hidden"
              ]
            },
            "sellAs": {
              "type": "string",
              "enum": [
                "user",
                "company"
              ],
              "description": "List as individual user or as linked company (requires a company profile)"
            },
            "existingImageUrls": {
              "type": "array",
              "maxItems": 12,
              "items": {
                "type": "string",
                "format": "uri"
              }
            }
          }
        },
        "UpdateProductRequest": {
          "type": "object",
          "minProperties": 1,
          "properties": {
            "title": {
              "type": "string"
            },
            "description": {
              "type": "string"
            },
            "category": {
              "type": "string"
            },
            "price": {
              "type": "number"
            },
            "condition": {
              "type": "string",
              "enum": [
                "new",
                "used",
                "like_new",
                "good",
                "fair"
              ]
            },
            "status": {
              "type": "string",
              "enum": [
                "draft",
                "active",
                "sold",
                "reserved",
                "hidden"
              ]
            },
            "replaceImages": {
              "type": "boolean",
              "description": "If true, replaces image set (old Cloudinary assets removed)"
            },
            "imageUrls": {
              "type": "array",
              "items": {
                "type": "string",
                "format": "uri"
              }
            }
          }
        },
        "CreatePostRequest": {
          "type": "object",
          "properties": {
            "productId": {
              "type": "string",
              "nullable": true
            },
            "type": {
              "type": "string",
              "enum": [
                "product",
                "general",
                "article_share"
              ]
            },
            "content": {
              "type": "string",
              "maxLength": 10000
            }
          }
        },
        "CreateCommentRequest": {
          "type": "object",
          "required": [
            "postId",
            "details"
          ],
          "properties": {
            "postId": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            },
            "details": {
              "type": "string",
              "maxLength": 4000
            }
          }
        },
        "ToggleLikeRequest": {
          "type": "object",
          "required": [
            "targetType",
            "targetId"
          ],
          "properties": {
            "targetType": {
              "type": "string",
              "enum": [
                "Post",
                "Comment",
                "Article"
              ]
            },
            "targetId": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        },
        "CreateReservationRequest": {
          "type": "object",
          "required": [
            "productId"
          ],
          "properties": {
            "productId": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            },
            "expiresAt": {
              "type": "string",
              "format": "date-time"
            }
          }
        },
        "UpdateReservationRequest": {
          "type": "object",
          "required": [
            "status"
          ],
          "properties": {
            "status": {
              "type": "string",
              "enum": [
                "pending",
                "accepted",
                "rejected",
                "cancelled",
                "expired",
                "completed"
              ]
            },
            "finalDecision": {
              "type": "string",
              "enum": [
                "none",
                "sold_to_user",
                "declined",
                "cancelled_by_buyer",
                "cancelled_by_seller"
              ]
            }
          }
        },
        "CreateArticleRequest": {
          "type": "object",
          "properties": {
            "title": {
              "type": "string",
              "maxLength": 300
            },
            "data": {
              "type": "object",
              "additionalProperties": true
            }
          }
        },
        "UpdateArticleRequest": {
          "type": "object",
          "minProperties": 1,
          "properties": {
            "title": {
              "type": "string"
            },
            "data": {
              "type": "object",
              "additionalProperties": true
            }
          }
        },
        "Article": {
          "type": "object",
          "description": "Platform news/article entry (admin-authored content for the home feed).",
          "properties": {
            "_id": {
              "type": "string",
              "example": "664f1a2b3c4d5e6f7a8b9c0d"
            },
            "authorId": {
              "type": "string",
              "description": "User id of the author (typically admin)"
            },
            "title": {
              "type": "string",
              "maxLength": 300,
              "example": "Solar incentives update 2026"
            },
            "data": {
              "type": "object",
              "additionalProperties": true,
              "description": "Flexible payload; often includes `body`, `coverUrl`, etc.",
              "example": {
                "body": "Short summary or full HTML/markdown content.",
                "coverUrl": "https://res.cloudinary.com/example/image/upload/v1/articles/cover.jpg"
              }
            },
            "likesCount": {
              "type": "integer",
              "minimum": 0,
              "example": 0
            },
            "commentsCount": {
              "type": "integer",
              "minimum": 0,
              "example": 0
            },
            "createdAt": {
              "type": "string",
              "format": "date-time"
            },
            "updatedAt": {
              "type": "string",
              "format": "date-time"
            }
          }
        },
        "ArticleListResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "description": "mongoose-paginate-v2 result",
              "properties": {
                "docs": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Article"
                  }
                },
                "totalDocs": {
                  "type": "integer"
                },
                "limit": {
                  "type": "integer"
                },
                "page": {
                  "type": "integer"
                },
                "totalPages": {
                  "type": "integer"
                },
                "hasNextPage": {
                  "type": "boolean"
                },
                "hasPrevPage": {
                  "type": "boolean"
                }
              }
            }
          }
        },
        "ArticleResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "$ref": "#/components/schemas/Article"
            }
          }
        },
        "CompanyEngineer": {
          "type": "object",
          "description": "Engineer profile linked to a company, with contact from the User record.",
          "properties": {
            "_id": {
              "type": "string"
            },
            "userId": {
              "type": "string"
            },
            "companyId": {
              "type": "string"
            },
            "yearsOfExperience": {
              "type": "number"
            },
            "rating": {
              "type": "number"
            },
            "certificate": {
              "type": "string"
            },
            "phoneWhatsapp": {
              "type": "string",
              "nullable": true,
              "description": "Personal WhatsApp/phone from linked User (`phoneWhatsapp`)"
            },
            "createdAt": {
              "type": "string",
              "format": "date-time"
            },
            "updatedAt": {
              "type": "string",
              "format": "date-time"
            }
          }
        },
        "CompanyEngineersListResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "array",
              "items": {
                "$ref": "#/components/schemas/CompanyEngineer"
              }
            }
          }
        },
        "CompanyProductsListResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "array",
              "description": "Products where `ownerModel` is `Company` and `ownerId` matches the company id",
              "items": {
                "type": "object",
                "additionalProperties": true
              }
            }
          }
        },
        "CompanyPostsListResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "array",
              "description": "Posts authored by the company owner's user id",
              "items": {
                "type": "object",
                "additionalProperties": true
              }
            }
          }
        },
        "WeatherCurrentResponse": {
          "type": "object",
          "description": "WeatherAPI `current.json` payload (passed through by the server).",
          "properties": {
            "location": {
              "type": "object",
              "properties": {
                "name": {
                  "type": "string"
                },
                "region": {
                  "type": "string"
                },
                "country": {
                  "type": "string"
                },
                "lat": {
                  "type": "number"
                },
                "lon": {
                  "type": "number"
                },
                "localtime": {
                  "type": "string"
                }
              }
            },
            "current": {
              "type": "object",
              "properties": {
                "temp_c": {
                  "type": "number"
                },
                "temp_f": {
                  "type": "number"
                },
                "condition": {
                  "type": "object",
                  "properties": {
                    "text": {
                      "type": "string"
                    },
                    "icon": {
                      "type": "string"
                    },
                    "code": {
                      "type": "integer"
                    }
                  }
                },
                "humidity": {
                  "type": "integer"
                },
                "wind_kph": {
                  "type": "number"
                },
                "last_updated": {
                  "type": "string"
                }
              }
            }
          }
        },
        "GenericSuccessResponse": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean",
              "example": true
            },
            "data": {
              "type": "object",
              "additionalProperties": true,
              "description": "Endpoint-specific payload (often paginated `docs` for list routes)"
            }
          }
        }
      },
      "responses": {
        "BadRequest": {
          "description": "Validation error — request body failed schema checks",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ValidationErrorResponse"
              },
              "example": {
                "success": false,
                "status": "fail",
                "message": "\"email\" must be a valid email"
              }
            }
          }
        },
        "Unauthorized": {
          "description": "Missing, invalid, or expired authentication token",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ErrorResponse"
              },
              "example": {
                "success": false,
                "status": "fail",
                "message": "Authentication required"
              }
            }
          }
        },
        "Forbidden": {
          "description": "Access denied — email not verified or token expired",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ErrorResponse"
              },
              "example": {
                "success": false,
                "status": "fail",
                "message": "Please verify your email before signing in"
              }
            }
          }
        },
        "NotFound": {
          "description": "Requested resource not found",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ErrorResponse"
              },
              "example": {
                "success": false,
                "status": "fail",
                "message": "User not found"
              }
            }
          }
        },
        "Conflict": {
          "description": "Resource conflict — duplicate entry",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ErrorResponse"
              },
              "example": {
                "success": false,
                "status": "fail",
                "message": "Email is already registered"
              }
            }
          }
        },
        "InternalError": {
          "description": "Unexpected server error",
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ErrorResponse"
              },
              "example": {
                "success": false,
                "status": "error",
                "message": "Internal server error"
              }
            }
          }
        }
      }
    },
    "paths": {
      "/health": {
        "get": {
          "tags": [
            "Health"
          ],
          "summary": "Health check",
          "description": "Returns a simple status object confirming the API is running.",
          "operationId": "healthCheck",
          "responses": {
            "200": {
              "description": "Server is healthy",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/HealthResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/weather": {
        "get": {
          "tags": [
            "News updates"
          ],
          "summary": "Current weather",
          "description": "Proxies [WeatherAPI](https://www.weatherapi.com/) **`/v1/current.json`** using the server-configured API key (`WEATHER_API_KEY` or `weatherApiKey` in environment).\n\nPass a location via **`q`** or **`city`**. If both are omitted, the server defaults to **`gaza`** (WeatherAPI may resolve ambiguous names to a best-match location).\n\n**Authentication:** not required (public endpoint).  \n**Express:** `GET /weather` in **`src/app.js`** (not under `/api`).\n",
          "operationId": "getCurrentWeather",
          "parameters": [
            {
              "name": "q",
              "in": "query",
              "required": false,
              "schema": {
                "type": "string"
              },
              "description": "WeatherAPI location query (e.g. city name or `lat,lon`). Preferred when set.",
              "example": "Gaza"
            },
            {
              "name": "city",
              "in": "query",
              "required": false,
              "schema": {
                "type": "string"
              },
              "description": "Alias for `q` when `q` is not sent.",
              "example": "Amman"
            }
          ],
          "responses": {
            "200": {
              "description": "Current conditions (`location` + `current` per WeatherAPI).",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/WeatherCurrentResponse"
                  },
                  "example": {
                    "location": {
                      "name": "Gaza",
                      "region": "",
                      "country": "Palestine",
                      "lat": 31.5,
                      "lon": 34.47,
                      "localtime": "2026-05-16 14:00"
                    },
                    "current": {
                      "temp_c": 22,
                      "temp_f": 71.6,
                      "condition": {
                        "text": "Clear",
                        "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                        "code": 1000
                      },
                      "humidity": 45,
                      "wind_kph": 12,
                      "last_updated": "2026-05-16 13:00"
                    }
                  }
                }
              }
            },
            "500": {
              "description": "Upstream error or unexpected failure",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "503": {
              "description": "Weather service is not configured (`WEATHER_API_KEY` / `weatherApiKey` missing)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "message": "Weather service is not configured (missing WEATHER_API_KEY)."
                  }
                }
              }
            }
          }
        }
      },
      "/api/auth/register": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Register a new account",
          "description": "Express route: **`POST /register`** on `src/modules/auth/auth.routes.js`, mounted under **`/api/auth`** → **`POST /api/auth/register`**.\n\nStores signup data on a **`PendingUser`** row (nothing in **`User`** yet) and sends a six-digit verification code.\n\n**409** if the email already exists in **`User`**. Calling register again with the same email **replaces** the previous pending signup and issues a fresh code.\n\n**Flow:** **`POST /api/auth/register`** → **`POST /api/auth/verify-email`** → **`POST /api/auth/assing-password`** → **`POST /api/auth/login`**.\n\n**`POST /api/auth/resend-verification`** accepts the same **`email`** if the code expires or delivery fails (**404** without a pending row).\n",
          "operationId": "register",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/RegisterRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Pending signup recorded — verification email sent. A **`User`** document is created only after **`POST /api/auth/verify-email`** succeeds.\n",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/RegisterResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "409": {
              "description": "Email already registered",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Email is already registered"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/assing-password": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Set password after registration",
          "description": "Express route: **`POST /assing-password`** on `src/modules/auth/auth.routes.js`, mounted under **`/api/auth`**.\n\nFull URL path: **`POST /api/auth/assing-password`**.\n\nFor newly promoted **`User`** records that do not yet have a password (**404** until **`verify-email`** has run).\n\nRequires the same **`email`** as registration. Returns **400** if a password is already set.\n\n**Recommended order:** **`verify-email`** first (creates **`User`** with verified email), then **`assing-password`**, then **`login`**. Login still requires a verified email and a password.\n",
          "operationId": "assingPassword",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/AssingPasswordRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Password saved",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/AssingPasswordResponse"
                  }
                }
              }
            },
            "400": {
              "description": "Password already assigned",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Password already assigned"
                  }
                }
              }
            },
            "404": {
              "description": "No user with this email",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "User not found"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/login": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Log in with email and password",
          "description": "Express route: **`POST /login`** on `src/modules/auth/auth.routes.js`, mounted under **`/api/auth`**.\n\nFull URL path: **`POST /api/auth/login`**.\n\nAuthenticates the user with email and password credentials for every role (`user`, `engineer`, `company`, `admin`).\nSuspended accounts cannot sign in until an admin activates them again.\nReturns **`UnifiedAuthPayload`** and sets a `refreshToken` cookie (`httpOnly`, `secure`, `sameSite=strict`, aligned with refresh token TTL, default 30 days).\n\nStricter **login rate limits** apply (default 5 attempts per minute per IP, in addition to the general auth route limiter).\n",
          "operationId": "login",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/LoginRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Login successful",
              "headers": {
                "Set-Cookie": {
                  "description": "Contains the `refreshToken` as an httpOnly secure cookie",
                  "schema": {
                    "type": "string",
                    "example": "refreshToken=eyJhbGci...; Max-Age=2592000; Path=/; HttpOnly; Secure; SameSite=Strict"
                  }
                }
              },
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/LoginResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "description": "Invalid email or password",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Invalid email or password"
                  }
                }
              }
            },
            "403": {
              "description": "Email not yet verified, account suspended, or company account not active yet (`role: company`)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Please verify your email before signing in"
                  }
                }
              }
            },
            "429": {
              "description": "Too many login attempts (login rate limiter)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/google-login": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Log in or register with Google",
          "description": "Authenticates using a Google OAuth2 ID token. If the user does not exist,\na new account is created automatically with `authProvider: \"google\"`.\nIf the user exists, the Google profile is linked.\nSuspended accounts cannot sign in until an admin activates them again.\n\nAny **`PendingUser`** row for the same verified Google email is removed after success (best-effort cleanup).\n",
          "operationId": "googleLogin",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/GoogleLoginRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Google login successful",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GoogleLoginResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "description": "Invalid or unverified Google token",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Invalid Google token"
                  }
                }
              }
            },
            "409": {
              "description": "Google account mismatch with existing user",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Google account does not match this user"
                  }
                }
              }
            },
            "500": {
              "description": "Google login not configured on the server",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "error",
                    "message": "Google login is not configured"
                  }
                }
              }
            }
          }
        }
      },
      "/api/auth/verify-email": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Verify email address",
          "description": "Validates the six-digit verification code against the **`PendingUser`** record for that email.\n\nOn success: creates the **`User`** with email already verified, copies profile fields from the pending row,\ndeletes **`PendingUser`**, and returns the sanitized **`user`** plus a message. Next step is usually\n**`POST /api/auth/assing-password`**.\n\n**409** if a **`User`** with this email already exists (e.g. duplicate request after success).\n",
          "operationId": "verifyEmail",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/VerifyEmailRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Email verified — **`User`** created; pending row removed",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/VerifyEmailResponse"
                  }
                }
              }
            },
            "400": {
              "description": "No pending registration, invalid email, or malformed body",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Invalid email or expired registration"
                  }
                }
              }
            },
            "403": {
              "description": "Verification token expired or invalid",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Verification token has expired"
                  }
                }
              }
            },
            "409": {
              "description": "A **`User`** with this email already exists",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Email already registered"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/resend-verification": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Resend email verification code",
          "description": "Express route: **`POST /resend-verification`** on `src/modules/auth/auth.routes.js`, mounted under **`/api/auth`** → **`POST /api/auth/resend-verification`**.\n\nOnly for **pending** signups (**`PendingUser`**). Generates a new six-digit code and refreshes token + TTL fields.\n\n**404** when there is no pending row for this email (including after **`verify-email`** has already promoted the account to **`User`**).\n",
          "operationId": "resendVerification",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ResendVerificationRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "New verification code emailed",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Verification code resent successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "404": {
              "description": "No pending registration for this email",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "No pending registration found for this email"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/forgot-password": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Request a password reset",
          "description": "Sends a six-digit password reset code to the user's registered email address.\nThe code is valid for 1 hour by default.\n",
          "operationId": "forgotPassword",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ForgotPasswordRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Password reset email sent",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Password reset email sent"
                    }
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "404": {
              "description": "No account found with this email",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Email not found"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/verify-password-reset-token": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Verify email reset code (step 2)",
          "description": "Validates the six-digit code from the forgot-password email. On success returns\n`passwordResetToken` — a short-lived JWT. Use it as `Authorization: Bearer <passwordResetToken>`\nwhen calling `POST /api/auth/reset-password` with only the new password in the body.\n",
          "operationId": "verifyPasswordResetToken",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/VerifyPasswordResetTokenRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Code valid; use passwordResetToken for reset-password",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/VerifyPasswordResetTokenResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "403": {
              "description": "Invalid or expired code",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "404": {
              "description": "Email not found",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/auth/resend-password-reset-token": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Resend password reset code",
          "description": "Express route: **`POST /resend-password-reset-token`** on `src/modules/auth/auth.routes.js`, mounted under **`/api/auth`** → **`POST /api/auth/resend-password-reset-token`**.\n\nGenerates a new six-digit password reset code, replaces the previously stored hash and expiry,\nand emails the new code to the user. Use this when the original code from `forgot-password` was\nlost or expired. Same effect as calling `forgot-password` again, but with clearer client semantics.\n",
          "operationId": "resendPasswordResetToken",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ResendPasswordResetTokenRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "New password reset code emailed",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Password reset code resent successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "404": {
              "description": "No account found with this email",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Email not found"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/reset-password": {
        "post": {
          "tags": [
            "Auth"
          ],
          "summary": "Set new password (step 3)",
          "description": "Body contains **only** the new `password`. Requires header\n`Authorization: Bearer <passwordResetToken>` from `verify-password-reset-token`.\nDo not send the six-digit email code in this request.\n",
          "operationId": "resetPassword",
          "security": [
            {
              "PasswordResetSessionAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ResetPasswordRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Password reset successfully",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Password reset successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "description": "Missing or invalid password-reset session JWT",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "403": {
              "description": "Email reset window expired after verification",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "404": {
              "description": "User not found",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/company/registration-info": {
        "get": {
          "tags": [
            "Company auth"
          ],
          "summary": "Company portal registration guidance",
          "description": "Public metadata describing the **company account** onboarding steps, privacy bullets, document rules,\nand OTP TTL (minutes). Implemented by **`src/routes/companyAuth.routes.js`** (`registration-info`).\n",
          "operationId": "companyRegistrationInfo",
          "responses": {
            "200": {
              "description": "Static flow copy and OTP window hint",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "success": {
                        "type": "boolean",
                        "example": true
                      },
                      "data": {
                        "$ref": "#/components/schemas/CompanyRegistrationInfoData"
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      "/api/auth/company/send-otp": {
        "post": {
          "tags": [
            "Company auth"
          ],
          "summary": "Send company registration OTP",
          "description": "Sends a six-digit code to the company email after verifying it is not already tied to a user account\nor an active/review company portal registration (`companySendOtpSchema` in **`src/models/validations/companyAuth.validation.js`**).\n",
          "operationId": "companySendOtp",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CompanySendOtpRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "OTP queued for delivery",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Verification code sent to your company email"
                    }
                  }
                }
              }
            },
            "409": {
              "description": "Email already used by a user or company portal account",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "429": {
              "description": "Auth rate limit exceeded (shared limiter with `/api/auth`)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/company/verify-otp": {
        "post": {
          "tags": [
            "Company auth"
          ],
          "summary": "Verify OTP and issue registration JWT",
          "description": "Validates the emailed OTP and returns a **`registrationToken`** JWT needed for **`POST /api/auth/company/register`**\n(`companyVerifyOtpSchema`).\n",
          "operationId": "companyVerifyOtp",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CompanyVerifyOtpRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "OTP verified — proceed to multipart registration",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "success": {
                        "type": "boolean",
                        "example": true
                      },
                      "data": {
                        "$ref": "#/components/schemas/CompanyVerifyOtpSuccessData"
                      }
                    }
                  }
                }
              }
            },
            "403": {
              "description": "Invalid or expired OTP",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "409": {
              "description": "Email conflict with existing user / company account",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "429": {
              "description": "Too many requests (rate limiter)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/auth/company/register": {
        "post": {
          "tags": [
            "Company auth"
          ],
          "summary": "Submit company portal registration (document, logo, fields)",
          "description": "**`multipart/form-data`** upload validated by **`companyRegisterSchema`** (**`src/models/validations/companyAuth.validation.js`**).\n\n- **`document`**: PDF / JPEG / PNG (≤10MB) — official company verification file; uploaded to Cloudinary, URL stored as **`Company.documentUrl`**.\n- **`logo`**: JPEG / PNG / WebP (≤10MB) — company logo; uploaded to Cloudinary, URL stored as **`Company.logo`**.\n- **`ownerName`**: legal/owner display name (2–200 chars); becomes **`Company.ownerName`** and user **`fullName`**.\n- **`registrationToken`**: JWT from **`/verify-otp`** (must match `email`).\n- **`password`**: Strong password — at least one lowercase, uppercase, digit, and special character (`^` pattern enforced server-side).\n- **`acceptPrivacyPolicy`**: must be truthy (`true`, `1`, `\"true\"`, etc.).\n\nCreates a **`User`** (role **`company`**, hashed password, email verified) and a **`Company`** with status **`pending_review`**. Admin approves → payment instructions → **`PATCH /api/admin/company-requests/:id/confirm-payment`** sets **`subscription`** and status **`active`**. Then **`POST /api/auth/login`** succeeds with the same email and password.\n\nExpress route: **`POST /register`** on **`src/routes/companyAuth.routes.js`** under **`/api/auth/company`**.\n",
          "operationId": "companyRegister",
          "requestBody": {
            "required": true,
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "required": [
                    "document",
                    "logo",
                    "registrationToken",
                    "companyName",
                    "ownerName",
                    "email",
                    "location",
                    "dateOfEstablishment",
                    "acceptPrivacyPolicy",
                    "password"
                  ],
                  "properties": {
                    "document": {
                      "type": "string",
                      "format": "binary",
                      "description": "Official verification document (PDF, JPEG, or PNG)"
                    },
                    "logo": {
                      "type": "string",
                      "format": "binary",
                      "description": "Company logo (JPEG, PNG, or WebP)"
                    },
                    "registrationToken": {
                      "type": "string"
                    },
                    "companyName": {
                      "type": "string",
                      "minLength": 2,
                      "maxLength": 300
                    },
                    "ownerName": {
                      "type": "string",
                      "minLength": 2,
                      "maxLength": 200,
                      "description": "Owner / authorized representative name for the public company profile"
                    },
                    "email": {
                      "type": "string",
                      "format": "email"
                    },
                    "location": {
                      "type": "string",
                      "minLength": 2,
                      "maxLength": 500
                    },
                    "dateOfEstablishment": {
                      "type": "string",
                      "format": "date",
                      "description": "Date of establishment (ISO 8601 date, cannot be in the future)"
                    },
                    "acceptPrivacyPolicy": {
                      "type": "boolean",
                      "description": "Accept privacy policy / registration instructions (also accepts `\"true\"` / `\"1\"` strings via multipart)"
                    },
                    "password": {
                      "type": "string",
                      "minLength": 8,
                      "maxLength": 128,
                      "description": "Strong password (mixed case, digit, special character required server-side)"
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Registration queued for admin review",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "success": {
                        "type": "boolean",
                        "example": true
                      },
                      "data": {
                        "$ref": "#/components/schemas/CompanyRegisterSuccessData"
                      }
                    }
                  }
                }
              }
            },
            "400": {
              "description": "Missing document, logo, policy acceptance, or invalid payload",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "401": {
              "description": "Invalid or expired `registrationToken`",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "409": {
              "description": "Email conflicts with existing records",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "429": {
              "description": "Too many requests (rate limiter)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            },
            "502": {
              "description": "Document upload failed",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/auth/company/login": {
        "post": {
          "tags": [
            "Company auth"
          ],
          "deprecated": true,
          "summary": "Deprecated — use unified login",
          "description": "**Deprecated.** Same behavior as **`POST /api/auth/login`**: authenticate a **`User`** with email/password (`companyLoginSchema`).\nReturns **`UnifiedAuthPayload`** and sets the standard **`refreshToken`** httpOnly cookie (not a separate company token).\n",
          "operationId": "companyLogin",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CompanyLoginRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Same as user login",
              "headers": {
                "Set-Cookie": {
                  "description": "Contains the `refreshToken` as an httpOnly secure cookie",
                  "schema": {
                    "type": "string"
                  }
                }
              },
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/LoginResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "description": "Unknown credentials",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "403": {
              "description": "Email not verified or company profile not active yet",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "429": {
              "description": "Too many login attempts (login rate limiter)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/admin/accounts/{userId}/suspend": {
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "description": "Account user id to suspend",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "patch": {
          "tags": [
            "Admin accounts"
          ],
          "summary": "Suspend an account",
          "description": "Admin-only endpoint. Sets `User.accountStatus` to `suspended`.\nSuspended accounts cannot sign in and existing Bearer tokens are rejected by auth middleware.\n",
          "operationId": "suspendAccount",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Account suspended",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "user": {
                        "_id": "664f1a2b3c4d5e6f7a8b9c0d",
                        "email": "ahmad.khalil@example.com",
                        "fullName": "Ahmad Khalil",
                        "role": "user",
                        "accountStatus": "suspended"
                      },
                      "message": "Account suspended successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "description": "Invalid user id or attempt to suspend own admin account",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/admin/accounts/{userId}/activate": {
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "description": "Account user id to activate",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "patch": {
          "tags": [
            "Admin accounts"
          ],
          "summary": "Activate an account",
          "description": "Admin-only endpoint. Sets `User.accountStatus` back to `active`.",
          "operationId": "activateAccount",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Account activated",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "user": {
                        "_id": "664f1a2b3c4d5e6f7a8b9c0d",
                        "email": "ahmad.khalil@example.com",
                        "fullName": "Ahmad Khalil",
                        "role": "user",
                        "accountStatus": "active"
                      },
                      "message": "Account activated successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/admin/accounts/{userId}": {
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "description": "Account user id to delete",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "delete": {
          "tags": [
            "Admin accounts"
          ],
          "summary": "Delete an account",
          "description": "Admin-only endpoint. Permanently deletes the target **User**, linked **Engineer** profile,\nand linked **Company** profile with Cloudinary profile/logo cleanup.\n\nDeletion is blocked while the account still owns products or authored posts, matching the\nexisting self-delete safeguards to avoid orphaned marketplace/social data.\n",
          "operationId": "deleteAccountByAdmin",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Account deleted",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Account deleted successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "description": "Invalid user id or attempt to delete own admin account",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "description": "Target account still owns listings or posts",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/users/me": {
        "get": {
          "tags": [
            "Users"
          ],
          "summary": "Get current user profile",
          "description": "Returns the full profile of the currently authenticated user.",
          "operationId": "getMe",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "User profile retrieved",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/UserResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        },
        "patch": {
          "tags": [
            "Users"
          ],
          "summary": "Update current user profile",
          "description": "Updates one or more fields on the authenticated user's profile.\nAt least one field must be provided.\n",
          "operationId": "updateMe",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/UpdateMeRequest"
                },
                "examples": {
                  "updateName": {
                    "summary": "Update display name only",
                    "value": {
                      "fullName": "Ahmad Khalil Al-Majali"
                    }
                  },
                  "updateAll": {
                    "summary": "Update several profile fields",
                    "value": {
                      "fullName": "Ahmad Khalil",
                      "birthDate": "1998-06-15",
                      "gender": "male",
                      "location": "Amman, Jordan",
                      "phoneWhatsapp": "+962791234567"
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Profile updated",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/UserResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        },
        "delete": {
          "tags": [
            "Users"
          ],
          "summary": "Delete current user account",
          "description": "Permanently deletes the authenticated **user**, any linked **engineer** profile, and the user's marketplace **`Company`**\nprofile (including Cloudinary profile photo & company logo assets).\n\n**Blocked** while content remains:\n- User-owned products (`ownerModel: User`)\n- Company-owned products for your linked `Company`\n- Posts authored by the user\n\nResolve **403** errors by removing listings/posts first. Uses **`DELETE /me`** on **`src/routes/user.routes.js`**.\n",
          "operationId": "deleteMyAccount",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Account removed",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Account deleted successfully"
                    }
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "description": "Marketplace listings or posts still present",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "examples": {
                    "postsRemain": {
                      "summary": "Posts exist",
                      "value": {
                        "success": false,
                        "status": "fail",
                        "message": "Remove your posts before deleting your account"
                      }
                    },
                    "productsRemain": {
                      "summary": "Products exist",
                      "value": {
                        "success": false,
                        "status": "fail",
                        "message": "Remove your product listings before deleting your account"
                      }
                    }
                  }
                }
              }
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/users/me/fcm-token": {
        "patch": {
          "tags": [
            "Users"
          ],
          "summary": "Update Firebase Cloud Messaging token",
          "description": "Stores or clears the device token used for push notifications (`fcmToken` on the user).\nSend `null` or empty string to unregister the device.\n",
          "operationId": "updateFcmToken",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/FcmTokenRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Token updated",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "FCM token updated"
                    }
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/users/change-password": {
        "patch": {
          "tags": [
            "Users"
          ],
          "summary": "Change password",
          "description": "Changes the authenticated user's password. Requires the current (old) password\nfor verification before setting the new one.\n",
          "operationId": "changePassword",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ChangePasswordRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Password changed successfully",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  },
                  "example": {
                    "success": true,
                    "data": {
                      "message": "Password changed successfully"
                    }
                  }
                }
              }
            },
            "400": {
              "description": "Validation error or incorrect current password",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Current password is incorrect"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            }
          }
        }
      },
      "/api/users/profile/picture": {
        "post": {
          "tags": [
            "Users"
          ],
          "summary": "Upload profile picture",
          "description": "Uploads a new profile picture for the authenticated user.\nThe image is stored on Cloudinary and the URL is saved to the user's profile.\nSend the image as a `multipart/form-data` field named `image`.\n",
          "operationId": "uploadProfilePicture",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "required": [
                    "image"
                  ],
                  "properties": {
                    "image": {
                      "type": "string",
                      "format": "binary",
                      "description": "Image file (JPEG, PNG, WebP, etc.)"
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Profile picture uploaded",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ProfilePictureResponse"
                  }
                }
              }
            },
            "400": {
              "description": "No image file provided",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Image file is required"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            },
            "500": {
              "$ref": "#/components/responses/InternalError"
            },
            "502": {
              "description": "Image upload service failed to return a URL",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "error",
                    "message": "Image upload did not return a URL"
                  }
                }
              }
            }
          }
        }
      },
      "/api/companies/me": {
        "get": {
          "tags": [
            "Companies"
          ],
          "summary": "Get my company",
          "description": "Returns the company owned by the authenticated user (`role: company`).\nResponse includes **`email`** from the linked **`User`** account.\n",
          "operationId": "getMyCompany",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Company document with `email`",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/companies/me/logo": {
        "post": {
          "tags": [
            "Companies"
          ],
          "summary": "Upload my company logo",
          "description": "Uploads or replaces the logo for the authenticated user's company without passing `companyId`.\nMultipart field **`image`**. Requires role **`company`** or **`admin`**. Response includes **`email`**.\n",
          "operationId": "uploadMyCompanyLogo",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "required": [
                    "image"
                  ],
                  "properties": {
                    "image": {
                      "type": "string",
                      "format": "binary"
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Company with updated `logo` URL and `email`",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/companies": {
        "get": {
          "tags": [
            "Companies"
          ],
          "summary": "List companies (paginated, active only)",
          "operationId": "listCompanies",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated companies",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        },
        "post": {
          "tags": [
            "Companies"
          ],
          "summary": "Create marketplace company profile",
          "description": "Creates the **`Company`** record linked to the authenticated **user** (`userId`). Requires role **`company`** or **`admin`**.\nValidates with **`createCompanySchema`** in **`src/models/validations/company.validation.js`**.\n\n**Not** the same as **company portal** registration (`POST /api/auth/company/register`), which submits verification documents and starts admin review.\n",
          "operationId": "createCompany",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CreateCompanyRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Company created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "409": {
              "$ref": "#/components/responses/Conflict"
            }
          }
        }
      },
      "/api/companies/{companyId}": {
        "parameters": [
          {
            "name": "companyId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "patch": {
          "tags": [
            "Companies"
          ],
          "summary": "Update company profile (owner info & subscription)",
          "description": "Partial update for the **`Company`** linked to the authenticated user. Only the owner (or permitted roles in service logic) may update.\nValidates with **`updateCompanySchema`** in **`src/models/validations/company.validation.js`** — send **at least one** of `ownerName`, `address`, `phone`, `description`, `dateOfEstablishment`, or nested **`subscription`** (`plan`, `startDate`, `endDate` ISO strings).\nResponse includes **`email`** from the linked **`User`** account.\n\nExpress route: **`PATCH /:companyId`** on **`src/routes/company.routes.js`**, mounted under **`/api/companies`**.\n",
          "operationId": "updateCompany",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/UpdateCompanyRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Updated company",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/companies/{companyId}/logo": {
        "post": {
          "tags": [
            "Companies"
          ],
          "summary": "Upload company logo",
          "description": "Multipart field `image`. Replaces previous logo on Cloudinary when set.\nResponse includes **`email`** from the linked **`User`** account.\n",
          "operationId": "uploadCompanyLogo",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "parameters": [
            {
              "name": "companyId",
              "in": "path",
              "required": true,
              "schema": {
                "type": "string",
                "pattern": "^[a-fA-F0-9]{24}$"
              }
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "required": [
                    "image"
                  ],
                  "properties": {
                    "image": {
                      "type": "string",
                      "format": "binary"
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Company with updated `logo` URL",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/companies/{companyId}/engineers": {
        "parameters": [
          {
            "name": "companyId",
            "in": "path",
            "required": true,
            "description": "Company id",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Companies"
          ],
          "summary": "List engineers for a company",
          "description": "Returns all engineer profiles linked to the given **`companyId`**, newest first.\n\nEach item includes **`phoneWhatsapp`** from the linked **`User`** record.\n\n**Authentication:** not required (public).  \n**Express:** `GET /:companyId/engineers` on **`src/routes/company.routes.js`**.\n",
          "operationId": "getCompanyEngineers",
          "responses": {
            "200": {
              "description": "Array of engineers (empty array if none)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/CompanyEngineersListResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "404": {
              "description": "Company not found",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/companies/{companyId}/products": {
        "parameters": [
          {
            "name": "companyId",
            "in": "path",
            "required": true,
            "description": "Company id",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Companies"
          ],
          "summary": "List products for a company",
          "description": "Returns marketplace products owned by the company (`ownerModel: Company`, `ownerId: companyId`), newest first.\n\n**Authentication:** not required (public).  \n**Express:** `GET /:companyId/products` on **`src/routes/company.routes.js`**.\n",
          "operationId": "getCompanyProducts",
          "responses": {
            "200": {
              "description": "Array of products (empty array if none)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/CompanyProductsListResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "404": {
              "description": "Company not found",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/companies/{companyId}/posts": {
        "parameters": [
          {
            "name": "companyId",
            "in": "path",
            "required": true,
            "description": "Company id",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Companies"
          ],
          "summary": "List posts for a company",
          "description": "Returns social posts authored by the company owner's **`User`** account (`authorId` = company `userId`), newest first.\n\n**Authentication:** not required (public).  \n**Express:** `GET /:companyId/posts` on **`src/routes/company.routes.js`**.\n",
          "operationId": "getCompanyPosts",
          "responses": {
            "200": {
              "description": "Array of posts (empty array if none)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/CompanyPostsListResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "404": {
              "description": "Company not found",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/engineers": {
        "get": {
          "tags": [
            "Engineers"
          ],
          "summary": "List engineers (paginated)",
          "operationId": "listEngineers",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            },
            {
              "name": "companyId",
              "in": "query",
              "description": "Filter by company",
              "schema": {
                "type": "string"
              }
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated engineers",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        },
        "post": {
          "tags": [
            "Engineers"
          ],
          "summary": "Register engineer profile",
          "description": "Requires role `engineer` or `admin`.",
          "operationId": "createEngineer",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CreateEngineerRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Engineer created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "description": "Referenced company does not exist",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Company not found"
                  }
                }
              }
            },
            "409": {
              "description": "This user already has an engineer profile",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ErrorResponse"
                  },
                  "example": {
                    "success": false,
                    "status": "fail",
                    "message": "Engineer profile already exists"
                  }
                }
              }
            }
          }
        }
      },
      "/api/engineers/me": {
        "get": {
          "tags": [
            "Engineers"
          ],
          "summary": "Get my engineer profile",
          "operationId": "getMyEngineer",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Engineer profile",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        },
        "patch": {
          "tags": [
            "Engineers"
          ],
          "summary": "Update my engineer profile",
          "operationId": "updateMyEngineer",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/UpdateEngineerRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Updated profile",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/products": {
        "get": {
          "tags": [
            "Products"
          ],
          "summary": "List products (paginated)",
          "operationId": "listProducts",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "name": "limit",
              "in": "query",
              "schema": {
                "type": "integer",
                "minimum": 1,
                "maximum": 50,
                "default": 12
              }
            },
            {
              "name": "category",
              "in": "query",
              "schema": {
                "type": "string"
              }
            },
            {
              "name": "status",
              "in": "query",
              "schema": {
                "type": "string",
                "enum": [
                  "draft",
                  "active",
                  "sold",
                  "reserved",
                  "hidden"
                ]
              }
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated products (`mongoose-paginate-v2` shape)",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        },
        "post": {
          "tags": [
            "Products"
          ],
          "summary": "Create product",
          "description": "`multipart/form-data`: JSON fields for `CreateProductRequest` plus optional files in `images` (up to 12).\nOr send `application/json` without files if only `existingImageUrls` are used (adjust client accordingly).\n",
          "operationId": "createProduct",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "required": [
                    "title",
                    "category",
                    "price",
                    "condition"
                  ],
                  "properties": {
                    "title": {
                      "type": "string"
                    },
                    "description": {
                      "type": "string"
                    },
                    "category": {
                      "type": "string"
                    },
                    "price": {
                      "type": "number"
                    },
                    "condition": {
                      "type": "string",
                      "enum": [
                        "new",
                        "used",
                        "like_new",
                        "good",
                        "fair"
                      ]
                    },
                    "status": {
                      "type": "string",
                      "enum": [
                        "draft",
                        "active",
                        "sold",
                        "reserved",
                        "hidden"
                      ]
                    },
                    "sellAs": {
                      "type": "string",
                      "enum": [
                        "user",
                        "company"
                      ]
                    },
                    "images": {
                      "type": "array",
                      "items": {
                        "type": "string",
                        "format": "binary"
                      }
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Product created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/products/{productId}": {
        "parameters": [
          {
            "name": "productId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Products"
          ],
          "summary": "Get product by ID",
          "operationId": "getProduct",
          "responses": {
            "200": {
              "description": "Product",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        },
        "patch": {
          "tags": [
            "Products"
          ],
          "summary": "Update product (owner only)",
          "operationId": "updateProduct",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "title": {
                      "type": "string"
                    },
                    "description": {
                      "type": "string"
                    },
                    "category": {
                      "type": "string"
                    },
                    "price": {
                      "type": "number"
                    },
                    "condition": {
                      "type": "string",
                      "enum": [
                        "new",
                        "used",
                        "like_new",
                        "good",
                        "fair"
                      ]
                    },
                    "status": {
                      "type": "string",
                      "enum": [
                        "draft",
                        "active",
                        "sold",
                        "reserved",
                        "hidden"
                      ]
                    },
                    "replaceImages": {
                      "type": "boolean"
                    },
                    "images": {
                      "type": "array",
                      "items": {
                        "type": "string",
                        "format": "binary"
                      }
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Updated product",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        },
        "delete": {
          "tags": [
            "Products"
          ],
          "summary": "Delete product (owner only)",
          "operationId": "deleteProduct",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Deleted",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/posts": {
        "get": {
          "tags": [
            "Social"
          ],
          "summary": "List posts (paginated)",
          "operationId": "listPosts",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            },
            {
              "name": "authorId",
              "in": "query",
              "schema": {
                "type": "string"
              }
            },
            {
              "name": "type",
              "in": "query",
              "schema": {
                "type": "string",
                "enum": [
                  "product",
                  "general",
                  "article_share"
                ]
              }
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated posts",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        },
        "post": {
          "tags": [
            "Social"
          ],
          "summary": "Create post (notifies followers)",
          "operationId": "createPost",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CreatePostRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Post created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/posts/{postId}": {
        "parameters": [
          {
            "name": "postId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Social"
          ],
          "summary": "Get post by ID",
          "operationId": "getPost",
          "responses": {
            "200": {
              "description": "Post",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        },
        "delete": {
          "tags": [
            "Social"
          ],
          "summary": "Delete my post",
          "operationId": "deletePost",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Deleted",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/comments": {
        "get": {
          "tags": [
            "Social"
          ],
          "summary": "List comments for a post",
          "operationId": "listCommentsForPost",
          "parameters": [
            {
              "name": "postId",
              "in": "query",
              "required": true,
              "schema": {
                "type": "string"
              }
            },
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "name": "limit",
              "in": "query",
              "schema": {
                "type": "integer",
                "minimum": 1,
                "maximum": 100
              }
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated comments",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        },
        "post": {
          "tags": [
            "Social"
          ],
          "summary": "Create comment (notifies post author)",
          "operationId": "createComment",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CreateCommentRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Comment created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/comments/{commentId}": {
        "parameters": [
          {
            "name": "commentId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "delete": {
          "tags": [
            "Social"
          ],
          "summary": "Delete my comment",
          "operationId": "deleteComment",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Deleted",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/likes": {
        "post": {
          "tags": [
            "Social"
          ],
          "summary": "Toggle like on post, comment, or article",
          "description": "Notifies the content owner when liking (not when unliking).",
          "operationId": "toggleLike",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ToggleLikeRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "{ liked: boolean }",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/reservations": {
        "post": {
          "tags": [
            "Reservations"
          ],
          "summary": "Create reservation (buyer)",
          "description": "Notifies the seller. Cannot reserve your own product.",
          "operationId": "createReservation",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CreateReservationRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Reservation created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/reservations/me": {
        "get": {
          "tags": [
            "Reservations"
          ],
          "summary": "List my reservations (buyer)",
          "operationId": "listMyReservations",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated reservations",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/reservations/seller": {
        "get": {
          "tags": [
            "Reservations"
          ],
          "summary": "List reservations for my products (seller)",
          "operationId": "listSellerReservations",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated reservations for owned products",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/reservations/{reservationId}": {
        "parameters": [
          {
            "name": "reservationId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "patch": {
          "tags": [
            "Reservations"
          ],
          "summary": "Update reservation status (seller)",
          "description": "Notifies the buyer. Seller must own the product.",
          "operationId": "updateReservation",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/UpdateReservationRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Updated reservation",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/articles": {
        "get": {
          "tags": [
            "News updates",
            "Articles"
          ],
          "summary": "List news articles (paginated)",
          "description": "Public paginated feed of platform articles/news. No authentication required.\n\nOptional **`authorId`** filters to a single author. Sorted by **`createdAt`** descending (newest first).\n\nPart of **News updates** for home screens; create/update/delete use the **Articles** tag on other methods.\n",
          "operationId": "listArticles",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            },
            {
              "name": "authorId",
              "in": "query",
              "required": false,
              "description": "Filter by author user id (24-char hex ObjectId)",
              "schema": {
                "type": "string",
                "pattern": "^[a-fA-F0-9]{24}$"
              }
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated articles",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ArticleListResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            }
          }
        },
        "post": {
          "tags": [
            "Articles"
          ],
          "summary": "Create article",
          "operationId": "createArticle",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/CreateArticleRequest"
                }
              }
            }
          },
          "responses": {
            "201": {
              "description": "Article created",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/articles/{articleId}": {
        "parameters": [
          {
            "name": "articleId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "News updates",
            "Articles"
          ],
          "summary": "Get news article by ID",
          "description": "Public single-article view for the news/home feed. No authentication required.",
          "operationId": "getArticle",
          "responses": {
            "200": {
              "description": "Article",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ArticleResponse"
                  }
                }
              }
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        },
        "patch": {
          "tags": [
            "Articles"
          ],
          "summary": "Update article (author only)",
          "operationId": "updateArticle",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/UpdateArticleRequest"
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Updated article",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "403": {
              "$ref": "#/components/responses/Forbidden"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        },
        "delete": {
          "tags": [
            "Articles"
          ],
          "summary": "Delete article (author only)",
          "operationId": "deleteArticle",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Deleted",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/articles/{articleId}/cover": {
        "parameters": [
          {
            "name": "articleId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "post": {
          "tags": [
            "Articles"
          ],
          "summary": "Upload article cover image",
          "description": "Stores URL in `data.coverUrl`. Field name `image`.",
          "operationId": "uploadArticleCover",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "requestBody": {
            "required": true,
            "content": {
              "multipart/form-data": {
                "schema": {
                  "type": "object",
                  "required": [
                    "image"
                  ],
                  "properties": {
                    "image": {
                      "type": "string",
                      "format": "binary"
                    }
                  }
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "Article with updated `data.coverUrl`",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      },
      "/api/users/{userId}/follow": {
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "description": "User to follow or unfollow",
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "post": {
          "tags": [
            "Follows"
          ],
          "summary": "Follow user",
          "operationId": "followUser",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "{ following: true }",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "400": {
              "$ref": "#/components/responses/BadRequest"
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        },
        "delete": {
          "tags": [
            "Follows"
          ],
          "summary": "Unfollow user",
          "operationId": "unfollowUser",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "{ following: false }",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/users/{userId}/followers": {
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Follows"
          ],
          "summary": "List followers of a user (paginated)",
          "operationId": "listFollowers",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/LimitFollow"
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated UserFollow docs",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/users/{userId}/following": {
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "get": {
          "tags": [
            "Follows"
          ],
          "summary": "List accounts this user follows (paginated)",
          "operationId": "listFollowing",
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/LimitFollow"
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated UserFollow docs",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            }
          }
        }
      },
      "/api/notifications/unread-count": {
        "get": {
          "tags": [
            "Notifications"
          ],
          "summary": "Unread notification count",
          "operationId": "unreadNotificationCount",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "{ unreadCount: number }",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/notifications": {
        "get": {
          "tags": [
            "Notifications"
          ],
          "summary": "List my notifications (paginated)",
          "operationId": "listNotifications",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "parameters": [
            {
              "$ref": "#/components/parameters/Page"
            },
            {
              "$ref": "#/components/parameters/Limit20"
            }
          ],
          "responses": {
            "200": {
              "description": "Paginated notifications",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/notifications/read-all": {
        "post": {
          "tags": [
            "Notifications"
          ],
          "summary": "Mark all notifications as read",
          "operationId": "markAllNotificationsRead",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Acknowledgement message",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/MessageResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            }
          }
        }
      },
      "/api/notifications/{notificationId}/read": {
        "parameters": [
          {
            "name": "notificationId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "pattern": "^[a-fA-F0-9]{24}$"
            }
          }
        ],
        "patch": {
          "tags": [
            "Notifications"
          ],
          "summary": "Mark one notification as read",
          "operationId": "markNotificationRead",
          "security": [
            {
              "BearerAuth": []
            }
          ],
          "responses": {
            "200": {
              "description": "Updated notification document",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/GenericSuccessResponse"
                  }
                }
              }
            },
            "401": {
              "$ref": "#/components/responses/Unauthorized"
            },
            "404": {
              "$ref": "#/components/responses/NotFound"
            }
          }
        }
      }
    }
  },
  "customOptions": {
    "persistAuthorization": true,
    "displayRequestDuration": true,
    "tryItOutEnabled": true,
    "filter": true,
    "tagsSorter": "alpha",
    "operationsSorter": "alpha"
  }
};
  url = options.swaggerUrl || url
  var urls = options.swaggerUrls
  var customOptions = options.customOptions
  var spec1 = options.swaggerDoc
  var swaggerOptions = {
    spec: spec1,
    url: url,
    urls: urls,
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout"
  }
  for (var attrname in customOptions) {
    swaggerOptions[attrname] = customOptions[attrname];
  }
  var ui = SwaggerUIBundle(swaggerOptions)

  if (customOptions.oauth) {
    ui.initOAuth(customOptions.oauth)
  }

  if (customOptions.preauthorizeApiKey) {
    const key = customOptions.preauthorizeApiKey.authDefinitionKey;
    const value = customOptions.preauthorizeApiKey.apiKeyValue;
    if (!!key && !!value) {
      const pid = setInterval(() => {
        const authorized = ui.preauthorizeApiKey(key, value);
        if(!!authorized) clearInterval(pid);
      }, 500)

    }
  }

  if (customOptions.authAction) {
    ui.authActions.authorize(customOptions.authAction)
  }

  window.ui = ui
}

