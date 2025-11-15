from sqlalchemy import Column, String, Enum
from sqlalchemy.ext.declarative import declarative_base
from enum import Enum as PyEnum
from .base import BaseModel, Base

class UserRole(PyEnum):
    USER = "user"
    ADMIN = "admin"

class User(Base, BaseModel):
    __tablename__ = "users"
    
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    full_name = Column(String)
    role = Column(Enum(UserRole), default=UserRole.USER)