"""user uploaded songs

Revision ID: 84a79256c2e3
Revises: 69e6acb117e4
Create Date: 2022-04-28 18:00:43.142059

"""
from alembic import op
import sqlalchemy as sa
import sqlalchemy_utils


# revision identifiers, used by Alembic.
revision = '84a79256c2e3'
down_revision = '69e6acb117e4'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('Songs',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('user_id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('music_title', sa.String(length=255), nullable=True),
    sa.Column('genre', sa.String(length=255), nullable=True),
    sa.Column('own_recording', sa.String(length=255), nullable=True),
    sa.Column('parties', sa.String(length=255), nullable=True),
    sa.Column('writers', sa.String(length=255), nullable=True),
    sa.Column('publishers', sa.String(length=255), nullable=True),
    sa.Column('audio_url', sa.String(length=255), nullable=True),
    sa.Column('image_url', sa.String(length=255), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['user.id'], ondelete='cascade'),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('Songs')
    # ### end Alembic commands ###
