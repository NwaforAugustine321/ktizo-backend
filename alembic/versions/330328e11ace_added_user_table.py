"""Added user table

Revision ID: 330328e11ace
Revises: 
Create Date: 2022-03-29 15:54:47.434331

"""
from alembic import op
import sqlalchemy as sa
import sqlalchemy_utils


# revision identifiers, used by Alembic.
revision = '330328e11ace'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('contact_details',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('name', sa.String(length=255), nullable=True),
    sa.Column('email', sa.String(length=255), nullable=True),
    sa.Column('user_role', sa.String(length=255), nullable=True),
    sa.Column('message', sa.String(length=255), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('email_details',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('full_name', sa.String(length=255), nullable=True),
    sa.Column('email', sa.String(length=255), nullable=True),
    sa.Column('user_role', sa.String(length=255), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email')
    )
    op.create_table('reset_password',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('email', sa.String(length=255), nullable=False),
    sa.Column('status', sa.Boolean(), nullable=False),
    sa.Column('reset_token', sa.String(length=255), nullable=False),
    sa.Column('expired_in', sa.DateTime(), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email'),
    sa.UniqueConstraint('expired_in'),
    sa.UniqueConstraint('reset_token')
    )
    op.create_table('song_ratings',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('song_id', sa.String(length=255), nullable=True),
    sa.Column('reviewer_id', sa.String(length=255), nullable=True),
    sa.Column('rate', sa.Integer(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('user',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('full_name', sa.String(length=255), nullable=True),
    sa.Column('email', sa.String(length=255), nullable=True),
    sa.Column('password', sa.String(length=255), nullable=True),
    sa.Column('age', sa.Integer(), nullable=True),
    sa.Column('spotify_artist_profile', sa.String(length=255), nullable=True),
    sa.Column('favourite_music_style', sa.String(length=255), nullable=True),
    sa.Column('favourite_music_mood', sa.String(length=255), nullable=True),
    sa.Column('yourown_music', sa.String(length=255), nullable=True),
    sa.Column('favourite_music_topic', sa.String(length=255), nullable=True),
    sa.Column('master', sa.String(length=255), nullable=True),
    sa.Column('publish_control', sa.String(length=255), nullable=True),
    sa.Column('outside_income', sa.String(length=255), nullable=True),
    sa.Column('established_artist', sa.String(length=255), nullable=True),
    sa.Column('company', sa.String(length=255), nullable=True),
    sa.Column('linkedin_profile', sa.String(length=255), nullable=True),
    sa.Column('project_seek_music', sa.String(length=255), nullable=True),
    sa.Column('turn_around_time', sa.String(length=255), nullable=True),
    sa.Column('project_budject', sa.String(length=255), nullable=True),
    sa.Column('syncs_seek', sa.String(length=255), nullable=True),
    sa.Column('token', sa.String(length=255), nullable=True),
    sa.Column('user_role', sa.String(length=255), nullable=True),
    sa.Column('spotify_user_id', sa.String(length=255), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email')
    )
    op.create_table('user_ratings',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('reviewee_id', sa.String(length=255), nullable=True),
    sa.Column('reviewer_id', sa.String(length=255), nullable=True),
    sa.Column('rate', sa.Integer(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('user_ratings')
    op.drop_table('user')
    op.drop_table('song_ratings')
    op.drop_table('reset_password')
    op.drop_table('email_details')
    op.drop_table('contact_details')
    # ### end Alembic commands ###