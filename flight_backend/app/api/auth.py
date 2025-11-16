from fastapi import APIRouter, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.schemas.user import UserCreate, UserLogin, Token
from app.models.user import User
from app.database.database import get_db
from app.core.rate_limiter import limiter
from app.core.rate_limit_config import (
    AUTH_RATE_LIMIT,
    AUTH_SIGNUP_RATE_LIMIT,
    AUTH_LOGIN_RATE_LIMIT,
    AUTH_REFRESH_RATE_LIMIT
)
from app.core.security import hash_password, verify_password, create_access_token

router = APIRouter()

@router.post("/signup", response_model=Token)
@limiter.limit(AUTH_SIGNUP_RATE_LIMIT)
def signup(request: Request, user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.email == user.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists",
        )

    db_user = User(
        email=user.email,
        full_name=user.full_name,
        password_hash=hash_password(user.password),
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    access_token = create_access_token({"sub": db_user.id})
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=Token)
@limiter.limit(AUTH_LOGIN_RATE_LIMIT)
def login(request: Request, form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = create_access_token({"sub": user.id})
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/refresh", response_model=Token)
@limiter.limit(AUTH_REFRESH_RATE_LIMIT)
def refresh_token(request: Request):
    # Refresh token logic
    return {"access_token": "new_placeholder_token", "token_type": "bearer"}