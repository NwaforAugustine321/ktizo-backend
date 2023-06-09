"""edited user table

Revision ID: a9ba741f87cd
Revises: 047e24351abe
Create Date: 2022-04-29 10:31:15.857367

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'a9ba741f87cd'
down_revision = '047e24351abe'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('user', sa.Column('legal_name', sa.String(length=255), nullable=True))
    op.add_column('user', sa.Column('profile_pic', sa.String(length=255), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('user', 'profile_pic')
    op.drop_column('user', 'legal_name')
    # ### end Alembic commands ###
